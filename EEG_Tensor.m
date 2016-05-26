%%
[hdr, record]=edfread('C:\Users\Emilia_P\Documents\MATLAB\Diploma\Diploma\Motor_Dataset\S001R03.edf');
frame_len=160;  % length of frame
overlap=0.5*frame_len;  % percentage of overlapping
%f=tensor(zeros(fix((length(record)-frame_len+overlap)/overlap),frame_len,size(record,1)-1)); % f=#frames*frame_length*#channels
for i=1:(size(record,1)-1)
    f(:,:,i)=enframe(record(i,:),frame_len,overlap); %split each signal of each electrode into frames of 160 samples, with 80 samples overlapping
end
nrec=size(record,1)-1;
nframe=fix((length(record)-frame_len+overlap)/overlap);
%Extract feature vectors for each frame of each channel
 parfor i=1:nrec
    for j=1:nframe
        fvec(j,:,i)= EEG_feature_extraction_v2(f(j,:,i)',160,160,6);
    end
 end
 
 %Normalize feature vectors along each time window
  for i=1:size(record,1)-1
    fvec_norm(:,:,i)=zscore(fvec(:,:,i));
  end
  nfvec=size(fvec_norm,1);

  disp('feature extraction done!\n')
  %%
% 
%   parfor j=1:nfvec
%       for i=1:nrec
%           for k=1:nrec
%               [rn,pn]=corrcoef(fvec_norm(j,:,i),fvec_norm(j,:,k));
%               T(i,k,j)=rn(2,1);
%               P(i,k,j)=pn(2,1);
%           end
%       end
%       disp(j)
%   end

  
    %%

  parfor j=1:nfvec
      for i=1:nfvec
          for k=1:nrec
              for m=1:nrec
                  [rn,pn]=corrcoef(fvec_norm(i,:,k),fvec_norm(j,:,m));
                  T(k,m,j,i)=rn(2,1);
                  P(k,m,j,i)=pn(2,1);
              end
          end
      end
      disp(j)
  end
  %%
%   T2=tensor(zeros(nfvec,nfvec,nrec));
%   P2=tensor(zeros(nfvec,nfvec,nrec));
%   C2=tensor(zeros(nfvec,nfvec,nrec));
%   parfor j=1:nrec
%       for i=1:nfvec
%           for k=1:nfvec
%               [rn,pn]=corrcoef(fvec_norm(i,:,j),fvec_norm(k,:,j));
%               T2(i,k,j)=rn(2,1);
%               P2(i,k,j)=pn(2,1);
%           end
%       end
%       disp(j)
%   end
  
%%
C=zeros(nrec,nrec,nfvec);
C(P<0.05)=1;
C(P>=0.05)=0;
C=tensor(C);
spC=sptensor(C);

C2=zeros(nfvec,nfvec,nrec);
C2(P2<0.05)=1;
C2(P2>=0.05)=0;
C2=tensor(C2);
spC2=sptensor(C2);




