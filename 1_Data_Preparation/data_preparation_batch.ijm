input_folder = getDirectory("Choose an input folder");
output_dir = getDirectory("Select output folder");

// Bio-Formats Macro Extensions
run("Bio-Formats Macro Extensions");

// Main function to process folders recursively
function processFolder(folder) {
    list = getFileList(folder);
    for (i = 0; i < list.length; i++) {
        path = folder + File.separator + list[i];
        if (File.isDirectory(path)) {
            processFolder(path);
        } else {
            if (endsWith(toLowerCase(list[i]), ".tif") || endsWith(toLowerCase(list[i]), ".czi")) {
                processBioformatsFile(path);
            }
        }
    }
}

// Function to process individual files
function processBioformatsFile(filePath) {
    print("Processing file: " + filePath);
    
    // Initialize Bio-Formats
    Ext.setId(filePath);
    Ext.getSeriesCount(seriesCount);
    print("Number of series: " + seriesCount);
    
    fileName = File.getNameWithoutExtension(filePath);
    
    for (series = 0; series < seriesCount; series++) {
        // Set the current series
        Ext.setSeries(series);
        Ext.getSeriesName(seriesName);
        print("\nProcessing Series " + (series + 1) + ": " + seriesName);
        Ext.getSizeC(channels);
        
        // Create directories
        seriesDir = output_dir + File.separator + fileName + "_series" + (series + 1);
        rawImageDir = seriesDir + File.separator + "raw_image";
        isotropicImageDir = seriesDir + File.separator + "isotropic_image";
        File.makeDirectory(seriesDir);
        File.makeDirectory(rawImageDir);
        File.makeDirectory(isotropicImageDir);
        
        // Save source info
        sourceInfoFile = File.open(seriesDir + File.separator + "source_info.txt");
        print(sourceInfoFile, "Source file: " + filePath);
        print(sourceInfoFile, "Series: " + (series + 1));
        print(sourceInfoFile, "Series name: " + seriesName);
        print(sourceInfoFile, "Number of channels: " + channels);
        File.close(sourceInfoFile);
        
        // Import the series
        run("Bio-Formats Importer", "open=[" + filePath + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_" + (series + 1));
        rename("temp_stack");
        
        // Define channel names
        channelNames = newArray(
            "C1-Icam2-Blood-Vessels",
            "C2-GFAP-Astrocytes-Activated_Mullerglia",
            "C3-Iba1-Microglia-Macrophages",
            "C4-DAPI",
            "C5-Empty"
        );
        
        if (channels > 1) {
            run("Split Channels");
            
            // Process each channel
            for (c = 1; c <= channels; c++) {
                if (c <= channelNames.length) {
                    channelName = channelNames[c-1];
                } else {
                    channelName = "C" + c + "-Channel";
                }
                
                // Save raw channel
                selectWindow("C" + c + "-temp_stack");
                saveAs("Tiff", rawImageDir + File.separator + channelName + ".tif");
                
                // Create and save isotropic version
                selectWindow(channelName + ".tif");
                run("Scale...", "x=0.8 y=0.8 z=3.7 interpolation=Bicubic average create");
                saveAs("Tiff", isotropicImageDir + File.separator + channelName + ".tif");
                // Close windows
                close();
                close();
                
                
                // Special processing for DAPI channel (C4)
                if (channelName == "C4-DAPI") {
                    open(isotropicImageDir + File.separator + channelName + ".tif");
                    run("Reslice [/]...", "output=1.000 start=Top avoid");
                    saveAs("Tiff", isotropicImageDir + File.separator + "C4-DAPI-XZ.tif");
                    close();
                    close();
                }
                
                
            }
        } else {
            // Process single channel image
            saveAs("Tiff", rawImageDir + File.separator + "single_channel.tif");
            selectWindow("single_channel.tif");
            run("Scale...", "x=0.8 y=0.8 z=3.7 interpolation=Bicubic average create");
            saveAs("Tiff", isotropicImageDir + File.separator + "single_channel.tif");
            close();
            close();
        }
        
        // Clean up
        run("Close All");
    }
}

// Start processing
print("\nStarting recursive folder processing...");
print("Input folder: " + input_folder);
print("Output folder: " + output_dir);

File.makeDirectory(output_dir);
processFolder(input_folder);

print("\nProcessing complete!");
run("Close All");