function [windowPrecision, windowAccuracy, windowSpecificity, windowSensitivity, windowF1] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP, windowTN)
    % PerformanceEvaluationWindow
    % Function to compute different performance indicators (Precision, accuracy, 
    % sensitivity/recall) at the object level
    %
    % [precision, sensitivity, accuracy] = PerformanceEvaluationwindow(TP, FN, FP)
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'TP'                Number of True  Positive objects
    %    'FN'                Number of False Negative objects
    %    'FP'                Number of False Positive objects
    %
    % The function returns the precision, accuracy and sensitivity

    windowPrecision = windowTP / (windowTP+windowFP);
    windowAccuracy = (windowTP+windowTN) / (windowTP+windowFP+windowFN+windowTN);
    windowSpecificity = windowTN / (windowTN+windowFP);
    windowSensitivity = windowTP / (windowTP+windowFN); % recall
    windowF1 = 2*windowTP / (2*windowTP + windowFP + windowFN);
end
