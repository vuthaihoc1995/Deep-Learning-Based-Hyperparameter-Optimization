function [Ergodic_U1_sim,Ergodic_U2_sim] = ErgodicSim(Ptx_dBm,sigma2,iteration,Omega_sr,Omega_ru1,Omega_ru2,Omega_su1,Omega_su2,Omega_sd,...
    K,N,err,Ith,a2,a1,epsi,ome)

    parfor ss = 1:length(Ptx_dBm)
        %%Simulation
        SNR_s2_U2 =0;
        SNR_s2_U1 = 0;
        for ii = 1:iteration
            %Random channel
            hsr = sqrt(Omega_sr/2).*(randn(K,1)+1i*randn(K,1));
            hru1 = sqrt(Omega_ru1/2).*(randn(K,1)+1i*randn(K,1));
            hru2 = sqrt(Omega_ru2/2).*(randn(K,1)+1i*randn(K,1));
            hsu1 = sqrt(Omega_su1/2).*(randn(1,1)+1i*randn(1,1));
            hsu2 = sqrt(Omega_su2/2).*(randn(1,1)+1i*randn(1,1));
            hsd = sqrt(Omega_sd/2).*(randn(N,1)+1i*randn(N,1));
            herr = sqrt(Omega_sd/2).*(randn(1,1)+1i*randn(1,1));
            % imperfect channel state information
            [hsd,~] = max(hsd,[],1);
            h_I = err*hsd + sqrt(1-err^2)*herr;

            % Dynamic control tranmit power
            Power = min(Ptx_dBm(ss),Ith/abs(h_I)^2);
            % SINR at user
            SNR_s2_U2 = Power*a2*(sum(abs(ctranspose(hsr)*hru2)).^2 + ome*abs(hsu2).^2)/( Power*a1*(sum(abs(ctranspose(hsr)*hru2)).^2 + ome*abs(hsu2).^2) + sigma2 );
            SNR_s1_U1 = Power*a1*(sum(abs(ctranspose(hsr)*hru1)).^2 + ome*abs(hsu1).^2)/( epsi*Power*a2*(sum(abs(ctranspose(hsr)*hru1)).^2 + ome*abs(hsu1).^2) + sigma2);

            % Ergodic capacity
            Ergodic_U2_sim(ii,ss) = log2(1 + SNR_s2_U2);
            Ergodic_U1_sim(ii,ss) = log2(1 + SNR_s1_U1);

        end
    end
    Ergodic_U1_sim = mean(Ergodic_U1_sim);
    Ergodic_U2_sim = mean(Ergodic_U2_sim);
end

