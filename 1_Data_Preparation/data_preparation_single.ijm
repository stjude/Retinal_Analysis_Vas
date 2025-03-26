// ===== User Inputs =====
input_image = "/path/to/input_image.tif";
output_dir = "/path/to/output";
sample_name = "MouseID123";
pipeline = "DAPI"; // or "BloodVessel"
// ========================

// Build output folders
sample_folder = output_dir + File.separator + sample_name;
raw_folder = sample_folder + File.separator + "raw_image";
iso_folder = sample_folder + File.separator + "isotropic";

File.makeDirectory(sample_folder);
File.makeDirectory(raw_folder);
File.makeDirectory(iso_folder);

// Print status
print("Input Image: " + input_image);
print("Mouse Name: " + mouse_name);
print("Pipeline: " + pipeline);

// Open the image
open(input_image);
rename("input_stack");

// Save raw image
raw_output_path = raw_folder + File.separator + pipeline + ".tif";
saveAs("Tiff", raw_output_path);

// Create isotropic version
run("Scale...", "x=0.8 y=0.8 z=3.7 interpolation=Bicubic average create");
iso_output_path = iso_folder + File.separator + pipeline + ".tif";
saveAs("Tiff", iso_output_path);

// If DAPI, do XZ reslice
if (pipeline == "DAPI") {
    open(iso_output_path);
    run("Reslice [/]...", "output=1.000 start=Top avoid");
    saveAs("Tiff", iso_folder + File.separator + pipeline + "-XZ.tif");
    close();
}

// Close windows
close(); // scaled image
close("input_stack");
run("Close All");

print("Processing complete!");