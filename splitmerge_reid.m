%% calcul des performances split_merge pour chaque paire
clc
clear
%tableau des identités
pairs_id;
%% initialisation des variables
dataTrain=[];
indice=[];
cam_length=[844,806,395,328,439,727,457,946];
% toolbox arbre KD
addpath(genpath('E:\PFE\code\toolbox_arbreKD\vlfeat-0.9.14'));
%% extraction des paramétres de la cam a
% cam a data to be used for training
for cam_a = 5
    fprintf('Extracting features from cam %d \n',cam_a)
    sm_matrices=[];
    indices=[];
    traindir=dir(campath(cam_a,:));
    l=length(traindir)-3;
    for p = 1:l
        f_a_pers=[];
        % message de progression
        if (mod(p,50)==0)
            fprintf('working on person %d out of %d \n',p,l)
        end
        % chemin de la personne à traiter
        perspath(p,:)=['',campath(cam_a,:),'\',traindir(p+3).name,''];
        imgdir=dir(perspath(p,:));
        li=length(imgdir)-2;
        % extraction des features dans les 5 images
        for im = 1:li
            %fprintf('working on image %d out of %d \n',im,li)
            % chemin de l'image
            imgpath=['',campath(cam_a,:),'\',traindir(p+3).name,'\',imgdir(im+2).name,''];
            % préparation de l'image pour l'extraction
            img=imread(imgpath); %img=imadjust(img,[.2 .3 0; .6 .7 1],[]);%imshow(img)
            img=imresize(img,[256 128]);
            % extraction et stockage des paramétres split_merge
            merged_img_rr=split_merge(img);
            f_a = extract_features(img,merged_img_rr);
            %f_a = extract_local_colors(img,32);
            f_a_pers=[f_a_pers,f_a];
        end
        % stockage des features de toutes les personnes
        [col,lig]=size(f_a_pers);
        sm_matrices=[sm_matrices,f_a_pers];
        indices=[indices, p*ones(1,lig)];
        Tou_train_sm{cam_a}=sm_matrices;
        indice_sm{cam_a}=indices;
    end
end
save('Tou_train_sm','Tou_train_sm');
save('indice_sm','indice_sm');
%pause(120);
%% extraction des parametres de la cam b
for cam_a = 5
    for cam_b = 2
        if (cam_a==cam_b)
            % exclure les paire identiques (1,1 2,2 ...)
            continue;
        else
            fprintf('Working on camera pair %d %d \n',cam_a,cam_b)
            %% détection des identités en commun entre les 2 caméras
            common=[];
            for i=1:size(idss,1)
                if ([idss(i,cam_a+1),idss(i,cam_b+1)]==[1 1])
                    common=[common,idss(i,1)];
                end
            end
            %% extraction des paramétres de la cam b
            testdir=dir(campath(cam_b,:));
            % extraction des personnes en commun seulement
            for p = 2:length(common)
                f_b_pers=[];
                % message de progression
                if (mod(p,25)==0)
                    fprintf('working on person %d out of %d ,number %d \n',p,length(common),common(p))
                end
                %chemin de la personne
                perspathb(p,:)=['',campath(cam_b,:),'\',num2str(common(p),'%04d'),''];
                imgdirb=dir(perspathb(p,:));
                li=length(imgdir);
                % extraction des features dans les 5 images
                for im = 1:li-2
                    %fprintf('working on image %d out of %d \n',im,li)
                    %chemin de l'image
                    imgpathb=['',campath(cam_b,:),'\',num2str(common(p),'%04d'),'\',imgdirb(im+2).name,''];
                    imgb=imread(imgpathb);
                    imgb_imresize(imgb,[256 128]);%imgb=imadjust(imgb,[.2 .3 0; .6 .7 1],[]);
                    %extraction des features
                    merged_imgb_rr=split_merge(imgb);
                    f_b = extract_features(imgb,merged_img_rr);
                    %f_b = extract_local_colors(imgb,32);
                    %stockage des features
                    pairDataTestsm.(['person',num2str(common(p),'%04d'),'']){im}=f_b;
                end
            end
            %sauvegarde des résultats
            dataTestsm{cam_a,cam_b}=pairDataTestsm;
            save('dataTestsm','dataTestsm');
            %% classification des données
            %initialisation
            ids_a=ids{cam_a}(4:length(ids{cam_a}));
            trainperson=cam_length(cam_a);
            testperson=length(common)-1;
            %lecture des donnèes de references et de tests
            % Load de la base de référence
            dataTrainPIs=Tou_train_sm{cam_a};
            indicedataTrainPIs=indice_sm{cam_a};
            %%% Load de la base de test
            dataBaseTestPIs=pairDataTestsm;
            %Construction de larbre-KD
            display 'Construction de l arbre-KD'
            TestPIs=1;%%% variable de vérification
            %%%%%%%%%%%  Contruction de l'arbre-KD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            dataTrain=double(dataTrainPIs);
            treePred =vl_kdtreebuild(dataTrain,'ThresholdMethod','MEAN');
            %%%%% identité des PIs de la base de référence%%%%%%%%%%%%%%%%%%
            indice=indicedataTrainPIs;
            %%%%% Base de Test
            dataBaseTest=dataBaseTestPIs;
            VoteMajPIs=[];  % 'VoteMaj' =  vecteur pour enregistrer les vecteurs de votes associés à toutes les personnes
            
            %Correspondance par le 1-NN
            display 'Correspondance par le 1-NN'
            
            PersonnesReconnues=0;
            for i=2:testperson
                Votes=zeros(trainperson,1);
                %%%%%%%%%%%%%%%%%calcul des correspondances%%%%%%%%%%%%%%%%%%%%%%
                fileTest=(['person',num2str(common(i),'%04d')]);
                %%% données de la ièmme personne test
                if (TestPIs) dataTest=double(cell2mat(dataBaseTest.(fileTest)(1:end))); end
                
                if(~isempty(dataTest))
                    
                    %%% correspondance de la ièmme personne avec les données de reference
                    [Nlinks, Nscores, matchedLinks]=PIs_match_KDTree(dataTest,treePred,dataTrain,1000);
                    idReferenceMatchedLinks=[];
                    matchedLinks=matchedLinks(:,:);
                    idReferenceMatchedLinks=indice(matchedLinks(2,:));
                    %%% Generer le vecteur de votes majoritaire
                    for k=1:length(idReferenceMatchedLinks)
                        Votes(idReferenceMatchedLinks(k))=Votes(idReferenceMatchedLinks(k))+1;
                    end
                    VoteMajPIs.(fileTest)=Votes;
                    %%%Chercher l'identité référence ayant le max de votes
                    [maximum,idMajoritaire]=max(Votes);
                    %%% Vérifier si la personne est bien reconnue
                    if (mod(i,25)==0)
                        fprintf(1,'La personne test %d est reconnue comme personne %d \n',common(i),ids_a(idMajoritaire));
                    end
                    resultat(i,1)=common(i);resultat(i,2)=ids_a(idMajoritaire);
                    if(ids_a(idMajoritaire)==common(i))
                        PersonnesReconnues=PersonnesReconnues+1 ;
                    end
                else
                    VoteMajPIs.(fileTest)=zeros(trainperson,1);
                end
            end
            resultat;
            display '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
            display '     Résultats                      '
            display '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
            fprintf('\t \t Taux de ré-identification = %.2f%%\n',(PersonnesReconnues/testperson)*100);
            reid_pct(cam_a,cam_b)=(PersonnesReconnues/testperson)*100;
            reid_result{cam_a,cam_b}=resultat;
            reid_votes{cam_a,cam_b}=VoteMajPIs;
        end
    end
end