% labelsToFiles.m
% Utility function
% imageLabeler exported .mat files => cropped images
% Make sure you report any errors, problems at:
% zsolt.deak01@gmail.com
% Version: 0.3b
% Not tested
% Usage:
%   Save the labelsToFiles.m to your working directory
%   Run the labelsToFiles() function
% Expected result:
%   folder created for each label
%   cropped images created
%CHANGELOG:
%   2023.04.24 - 0.1b -> 0.2b
%   Output image type changed from jpg to png
%   2023.05.13 - 0.2b -> 0.3b
%   Index exceeds array bounds

function [] = labelsToFiles()
    directoryFiles = dir ("*.mat"); %choose all files from the current directory which ends in .mat
    numberOfMatFiles = length(directoryFiles); %number of files

    for matFileIndex= 1 : numberOfMatFiles
        currentMatFile = directoryFiles(matFileIndex).name; %current file name
        MatFilesContent(matFileIndex) = load(currentMatFile); %load the content of the files
        currentContent = MatFilesContent(matFileIndex); %choose the current content
        numberOfLabels = width(currentContent.gTruth.LabelData); %number of labels
        numberOfImages = height(currentContent.gTruth.DataSource.Source); %number of images
        for labelIndex=1: numberOfLabels
            currentLabelName = string(currentContent.gTruth.LabelDefinitions{labelIndex, 1}); %name of the current label
            outPutImageData = currentContent.gTruth.LabelData.(currentLabelName); %data of the cropped image
            if not(isfolder((lower(currentLabelName)))) %create the folder with the current label name if not exists
                mkdir(lower(currentLabelName)) 
            end
            cd(lower(currentLabelName)); %change directory to the current label
            for imageIndex=1: numberOfImages
                currentImage = imread(currentContent.gTruth.DataSource.Source{imageIndex}); %Load the original image 
                content = outPutImageData{imageIndex, 1}; %positions of the cropped images
                contentLength = height(content); %length of the positions ~ how many cropped images we have
                [rows, columns, numberOfColorChannels] = size(currentImage);
                for outPutImageIndex=1 : contentLength
                    outOfRowIndex = 0; %Not exceed image size
                    outOfColumnIndex = 0; %Not exceed image size
                    if content(outPutImageIndex, 1)+content(outPutImageIndex, 3) > columns
                        outOfColumnIndex = 1; %Exceed image size
                    end
                    if content(outPutImageIndex, 2)+content(outPutImageIndex, 4) > rows
                        outOfRowIndex = 1; %Exceed image size
                    end
                    outPutImage = currentImage(content(outPutImageIndex, 2):content(outPutImageIndex, 2)+content(outPutImageIndex, 4) - outOfRowIndex, content(outPutImageIndex, 1):content(outPutImageIndex, 1)+content(outPutImageIndex, 3) - outOfColumnIndex, :); % crop the image
                    imwrite(outPutImage, currentMatFile + "_" + lower(currentLabelName) + "_" + imageIndex + "_" + outPutImageIndex + ".png"); %create the cropped file
                    %image(outPut(j,2):outPut(j, 2)+outPut(j, 4), outPut(j,1):outPut(j,1)+outPut(j,3), :);
                end
                %imshow(currentImage); -> show current image
            end
            cd(".."); %move back to original directory
        end
    end
end