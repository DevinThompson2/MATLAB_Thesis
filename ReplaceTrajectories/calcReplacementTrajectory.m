function [out,placementFrame] = calcReplacementTrajectory(missingMarker,aRef,bRef,cRef,sFrame)

    % Goal: Determine starting location based on FRM, WR and FIN Markers if
    % available
    
    % (1) Find the first frame that all three reference markers have a
    % known position
    firstFrame_aRef = min(find(aRef(:,4) == 1));
    firstFrame_bRef = min(find(bRef(:,4) == 1));
    firstFrame_cRef = min(find(cRef(:,4) == 1));
    placementFrame = max([sFrame,firstFrame_aRef,firstFrame_bRef,firstFrame_cRef]);
    
    % (2) Find the average distance between the reference markers over the
    % rest of the trial
    aCommonInterval = intersect(find(aRef(:,4) == 1), find(missingMarker(:,4) == 1));
    bCommonInterval = intersect(find(bRef(:,4) == 1), find(missingMarker(:,4) == 1));
    cCommonInterval = intersect(find(cRef(:,4) == 1), find(missingMarker(:,4) == 1));
    allCommonInterval = intersect(aCommonInterval, intersect(bCommonInterval,cCommonInterval));
          
%     dist_aRef = sqrt(sum((aRef(aCommonInterval,1:3)-missingMarker(aCommonInterval,1:3)).^2,2)); 
%     dist_bRef = sqrt(sum((bRef(bCommonInterval,1:3)-missingMarker(aCommonInterval,1:3)).^2,2));
%     dist_cRef = sqrt(sum((cRef(cCommonInterval,1:3)-missingMarker(aCommonInterval,1:3)).^2,2));
    dist_aRef = sqrt(sum((aRef(aCommonInterval,1:3)-missingMarker(aCommonInterval,1:3)).^2,2)); 
    dist_bRef = sqrt(sum((bRef(bCommonInterval,1:3)-missingMarker(bCommonInterval,1:3)).^2,2));
    dist_cRef = sqrt(sum((cRef(cCommonInterval,1:3)-missingMarker(cCommonInterval,1:3)).^2,2));
    
    % (3) Use the average distance to triangulate the replacement position
    % of the missing marker
    P = [aRef(placementFrame,1:3),...
         bRef(placementFrame,1:3),...
         cRef(placementFrame,1:3)];
    
    S = [mean(dist_aRef), mean(dist_bRef), mean(dist_cRef)];    
     
    guess = [mean([aRef(placementFrame,1),bRef(placementFrame,1),cRef(placementFrame,1)]),...
             mean([aRef(placementFrame,2),bRef(placementFrame,2),cRef(placementFrame,2)]),...
             mean([aRef(placementFrame,3),bRef(placementFrame,3),cRef(placementFrame,3)])];
             
    input = [P,S];
    f = @(y) myfun(y,input);
    options = optimoptions(@fmincon,'MaxFunctionEvaluations',1000); % was 5000
    [out,fval] = fsolve(f,guess,options);
    
    % Check outputted value
    distCheckA = sqrt(sum((aRef(placementFrame,1:3)-out).^2,2))
    distCheckB = sqrt(sum((bRef(placementFrame,1:3)-out).^2,2))
    distCheckC = sqrt(sum((cRef(placementFrame,1:3)-out).^2,2))
    
    100*(S(1) - distCheckA) / S(1)
    100*(S(2) - distCheckB) / S(2)
    100*(S(3) - distCheckC) / S(3)
    
    
end