clear;
clc;

// Funções
function [expec_number_of_data, number_of_data, diff]= verify_registers(send_time)

    number_of_data = size(send_time)(1);
    first_sd = send_time(1);
    last_sd = send_time(size(send_time)(1));
    delta_sd = (last_sd - first_sd).duration/1000;
    expec_number_of_data = delta_sd/df_step(i);
    diff = expec_number_of_data - number_of_data;
    
    disp(msprintf("Primeiro registro %s;", string(first_sd)));
    disp(msprintf("Último registro %s;", string(last_sd)));
    disp(msprintf("Tempo de experimento %.f s;", delta_sd));        
    disp(msprintf("Número esperado de registros %.f;", expec_number_of_data));
    disp(msprintf("Quantidade de registros %.0f", number_of_data));
    disp(msprintf("Diferença %.0f", diff));

endfunction


// Programa principal

data_files = ["Teste 1 - 1 ESP 32 - pub 1 s.csv","Teste 2 - 1 ESP32 - pub 0.01s.csv","Teste 3 - 1 ESP32 - pub 0.1s.csv","Teste 4 - 2 - ESP32 - pub 0.1s.csv"];
df_step = [1,0.01,0.1,0.1];
hpa_files = ['Teste 2 - 1 ESP32 - pub 0.01s - HPA.csv' 'Teste 3 - 1 ESP32 - pub 0.1s - HPA.csv' 'Teste 4 - 2 ESP32 - pub 0.1s - HPA.csv'];
number_of_hist_classes = 20;

for i = 1:size(data_files)(2)
    f = data_files(i);
    disp(f)
    dados =  read_csv(f);
    send_time = datetime(dados(:,3));
    rec_time = datetime(dados(:,1));
    
    if (4 == size(dados)(2))

        ips = unique(dados(:,4));
        
        for j = 1:size(ips)(1)
            ip = ips(j);
            disp(ip);
            rt = rec_time(find(dados(:,4)==ip));
            sd = send_time(find(dados(:,4)==ip));
            diff_time = rt - sd;
            
            verify_registers(sd);
            
            media = mean(diff_time.duration);
            disp(msprintf("Média: %f s", media));
            
            desvpad = stdev(diff_time.duration);
            disp(msprintf("Desvio padrão: %f´s", desvpad));
            
            maior = max(diff_time.duration);
            menor = min(diff_time.duration);
            dx = (maior - menor)/number_of_hist_classes;
            x = menor:dx:maior;
        
            fig = figure(i+10*j);
            plot(diff_time.duration / 1000);
            title(data_files(i) + " IP ESP32: " + ips(j));
            xlabel("Amostra");
            ylabel("Tempo de envio (s)");
            xgrid;
            
            xs2png(fig, data_files(i)+" "+ips(j) + ".png");
            
            fig = figure(i+10*j + 100);           
            hist = histplot(x, diff_time.duration,normalization=%f)
            
            p = hist / sum(hist);
            dist_p = x(1:number_of_hist_classes) .* p;
            //disp([x(1:number_of_hist_classes)' hist' p' dist_p']);
            esp = sum(dist_p);
            disp(msprintf("Esperanca: %f s", esp));
                        
            titulo = msprintf("Histograma: %s IP ESP32: %s", data_files(i), ips(j));            
            estat_dados = msprintf("Média = %.1f s \n Desv Pad = %.1f s \n Esperança = %.1f s", media, desvpad, esp);
            title(titulo);
            // Obtendo os limites dos eixos para calcular a posição
            xlim = gca().data_bounds(:, 1); // Limites do eixo x
            ylim = gca().data_bounds(:, 2); // Limites do eixo y 
            xstring(xlim(2) - 0.2*xlim(2), ylim(2) - 0.1*ylim(2), estat_dados);
            
            xs2png(fig, titulo+".png");
            
            disp("================================================================");
         end
    else
        
        verify_registers(send_time);
        
        diff_time = rec_time - send_time;
        media = mean(diff_time.duration);
        disp(msprintf("Média: %f s", media));        
        desvpad = stdev(diff_time.duration);
        disp(msprintf("Desvio Padrão: %f s", desvpad));  
        
        maior = max(diff_time.duration);
        menor = min(diff_time.duration);
        dx = (maior - menor)/number_of_hist_classes;
        x = menor:dx:maior;       
        
        fig = figure(i);
        plot(diff_time.duration / 1000);
        title(data_files(i));
        xlabel("Amostra");
        ylabel("Tempo de envio (s)");
        xgrid;
        
        xs2png(fig, data_files(i)+".png");
        
        fig = figure(i+100);
        hist = histplot(x, diff_time.duration,normalization=%f)
            
        p = hist / sum(hist);
        dist_p = x(1:number_of_hist_classes) .* p;
        //disp([x(1:number_of_hist_classes)' hist' p' dist_p']);
        esp = sum(dist_p);
        disp(msprintf("Esperanca: %f s", esp));
            
        titulo = msprintf("Histograma: %s", data_files(i));            
        estat_dados = msprintf("Média = %.1f s \n Desv Pad = %.1f s \n Esperança = %.1f s", media, desvpad, esp);
        title(titulo);
        // Obtendo os limites dos eixos para calcular a posição
        xlim = gca().data_bounds(:, 1); // Limites do eixo x
        ylim = gca().data_bounds(:, 2); // Limites do eixo y
        xstring(xlim(2) - 0.2*xlim(2), ylim(2) - 0.1*ylim(2), estat_dados);
        xs2png(fig, titulo+".png");
        
        disp("================================================================");
    end
    
end

