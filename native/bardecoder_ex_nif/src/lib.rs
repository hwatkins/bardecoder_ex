use bardecoder;
use bardecoder::detect::{Detect, Location, LineScan};
use bardecoder::util::qr::{QRLocation};

use image;
use image::GrayImage;

use std::cell::RefCell;
use std::rc::Rc;

use rustler::{Binary,NifStruct};


#[derive(Debug, NifStruct, Clone)]
#[module = "BardecoderEx.Point"]
pub struct Point {
    pub x: i32,
    pub y: i32,
}

#[derive(Debug, NifStruct, Clone)]
#[module = "BardecoderEx.Metadata"]
pub struct MetaData {
    /// The version/size of the grid
    pub version: usize,
    /// the error correction leven, between 0 and 3
    pub ecc_level: u16,
    pub bounds: Vec<(i32, i32)>,
}

struct LeakLocationsDetector<'a> {
    real_detector: Box<dyn Detect<GrayImage> + 'a>,
    pub locations: Rc<RefCell<Vec<Location>>>
}

impl<'a> LeakLocationsDetector<'a> {
    pub fn new(real_detector: Box<impl Detect<GrayImage> +'a>) -> LeakLocationsDetector<'a> {
        LeakLocationsDetector {
            real_detector: real_detector,
            locations: Rc::new(RefCell::new(Vec::new()))
        }
    }

    pub fn get_locations(&self) -> Rc<RefCell<Vec<Location>>> {
        self.locations.clone()
    }
}

impl<'a> Detect<GrayImage> for LeakLocationsDetector<'a> {
    fn detect(self: &'_ Self, prepared: &GrayImage) -> Vec<Location> {
        let locations = self.real_detector.detect(prepared);        
        let mut mylocs = self.locations.borrow_mut();

        *mylocs = locations.iter().map(|Location::QR(l)| Location::QR(QRLocation{            
            top_left: l.top_left,
            bottom_left: l.bottom_left,
            top_right: l.top_right,
            module_size: l.module_size,
            version: l.version
        })).collect();

        locations
    }
}

#[rustler::nif]
fn detect_qr_codes(bytes: Binary) -> Result<Vec<Result<(MetaData, String), String>>, String> {
    match image::load_from_memory(bytes.as_slice()) {
        Ok(img) => {
            let mut db = bardecoder::default_builder_with_info();            
            let detector = LeakLocationsDetector::new(Box::new(LineScan::new()));
            let locations = detector.get_locations();
            db.detect(Box::new(detector));
            let decoder = db.build();
            let decoded = decoder.decode(&img);
            let mut results = Vec::new();
            
            for loc in &*locations.borrow() {
                println!("Loca {:?}", loc);
            }
            let mut i = 0;
            for result in decoded {
                match result {
                    Ok((content, info)) => {
                        let cur_loc = &(locations.borrow())[i];
                        i += 1;
                        let loc = match cur_loc {
                            Location::QR(l) => l
                        };
                        let fourth = (
                            (loc.top_left.x + (loc.top_right.x - loc.bottom_left.x)) as i32,
                            (loc.top_left.y + (loc.bottom_left.y - loc.top_right.y)) as i32
                        );
                        let bounds = vec![
                            (loc.top_left.x as i32, loc.top_left.y as i32),
                            (loc.top_right.x as i32, loc.top_right.y as i32),
                            fourth,
                            (loc.bottom_left.x as i32, loc.bottom_left.y as i32)
                        ];                        
                        results.push(
                        Ok(
                        (
                            MetaData {
                                version: info.version as usize,
                                ecc_level: info.ec_level as u16,
                                bounds: bounds
                            },
                            content.clone(),
                        )
                    )
                    )        
                    }
                    Err(error) => {
                        results.push(Err(error.to_string()))
                    }
                }
            };

            Ok(results)
        }
        Err(error) => Err(error.to_string()),
    }
}
rustler::init!("Elixir.BardecoderEx", [detect_qr_codes]);
