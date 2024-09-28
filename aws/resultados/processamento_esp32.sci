clear;
clc;

// Constantes

DATA_FILES = ["Teste 01 - 1 ESP32 - Pub 1 s.csv" "Teste 02 - 1 ESP32 - Pub 0.01 s.csv" "Teste 03 - 2 ESP32 - Pub 0.01 s.csv" "Teste 04 - 1 ESP32 - Pub 0.001 s.csv"];
DF_STEP = [1,0.01,0.01,0.001];
HPA_FILES = ["Teste 01 - 1 ESP32 - Pub 1 s - HPA.csv" "Teste 02 - 1 ESP32 - Pub 0.01 s - HPA.csv" "Teste 03 - 2 ESP32 - Pub 0.01 s - HPA.csv" "Teste 04 - 1 ESP32 - Pub 0.001 s - HPA.csv"];
NUMBER_OF_HIST_CLASSES = 20;

// Funções
function [expec_number_of_data, number_of_data, diff]= verify_registers(send_time)

    number_of_data = size(send_time)(1);
    first_sd = send_time(1);
    last_sd = send_time(size(send_time)(1));
    delta_sd = (last_sd - first_sd).duration/1000;
    expec_number_of_data = delta_sd/DF_STEP(i);
    diff = expec_number_of_data - number_of_data;
    
    disp(msprintf("Primeiro registro %s;", string(first_sd)));
    disp(msprintf("Último registro %s;", string(last_sd)));
    disp(msprintf("Tempo de experimento %.f s;", delta_sd));        
    disp(msprintf("Número esperado de registros %.f;", expec_number_of_data));
    disp(msprintf("Quantidade de registros %.0f", number_of_data));
    disp(msprintf("Diferença %.0f", diff));

endfunction

function plot_and_save_diff(fig_num, diff_time, filename)
    fig = figure(fig_num);
    fig.figure_size = [1024, 768];
    plot(diff_time.duration / 1000);
    title(filename);
    xlabel("Amostra");
    ylabel("Tempo de envio (s)");
    xgrid;
    xs2png(fig, filename + ".png");
endfunction

function esperanca = plot_and_save_histogram(fig_num, diff_time, media, desvpad, titulo)
    
    maior = max(diff_time.duration);
    menor = min(diff_time.duration);
    dx = (maior - menor)/NUMBER_OF_HIST_CLASSES;
    x = menor:dx:maior;
            
    fig = figure(fig_num);
    fig.figure_size = [1024, 768];
    hist = histplot(x, diff_time.duration,normalization=%f)
            
    p = hist / sum(hist);
    dist_p = x(1:NUMBER_OF_HIST_CLASSES) .* p;
    //disp([x(1:number_of_hist_classes)' hist' p' dist_p']);
    esperanca = sum(dist_p);
    disp(msprintf("Esperanca: %f s", esperanca));    
    estat_dados = msprintf("Média = %.1f ms \n Desv Pad = %.1f ms \n Esperança = %.1f ms", media, desvpad, esperanca);
    title(titulo);
    // Obtendo os limites dos eixos para calcular a posição
    xlim = gca().data_bounds(:, 1); // Limites do eixo x
    ylim = gca().data_bounds(:, 2); // Limites do eixo y 
    xstring(xlim(2) - 0.2*xlim(2), ylim(2) - 0.1*ylim(2), estat_dados);
            
    xs2png(fig, titulo+".png");
endfunction

function plot_and_save_sendXrec(fig_num, send_time, rec_time, time_mark, pod_number, cpu_load, filename)
    fig = figure(fig_num);
    fig.figure_size = [1024, 768];
    plot(rec_time.time, send_time.time,'+b');
    title(filename);
    xlabel("Instante de recebimento (s)");
    ylabel("Instante de envio (s)");
    xgrid;
    
    ax3 = newaxes();
    set(ax3, "filled", "off");
    plot(time_mark.time, pod_number, 'r', time_mark.time, cpu_load, 'k');
    ylabel("% de carga da CPU  e número de PODs")
    ax3.y_location = "right";
    ax3.axes_visible(1) = "off";
    
    xs2png(fig, filename + ".png");
endfunction

// Programa principal


for i = 1:size(DATA_FILES)(2)
    f = DATA_FILES(i);
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
            disp(msprintf("Média: %f ms", media));
            
            desvpad = stdev(diff_time.duration);
            disp(msprintf("Desvio padrão: %f ms", desvpad));
            
            filename = DATA_FILES(i) + " IP ESP32: " + ips(j);
            plot_and_save_diff(i+10*j, diff_time, filename);
            
            titulo = msprintf("Histograma: %s IP ESP32: %s", DATA_FILES(i), ips(j));
            plot_and_save_histogram(i+10*j + 100, diff_time, media, desvpad, titulo);
            hpa_data = read_csv(HPA_FILES(i));
            cpu_load = strtod(hpa_data(:,1));
            pod_number = strtod(hpa_data(:,2));
            time_mark = datetime(hpa_data(:,4));
            plot_and_save_sendXrec(i+10*j+200, send_time, rec_time, time_mark, pod_number, cpu_load, filename + " - sendXrec");
            
            sleep(50)
            disp("================================================================");
         end
    else
        
        verify_registers(send_time);
        
        diff_time = rec_time - send_time;
        media = mean(diff_time.duration);
        disp(msprintf("Média: %f ms", media));        
        desvpad = stdev(diff_time.duration);
        disp(msprintf("Desvio Padrão: %f ms", desvpad));  

        plot_and_save_diff(i, diff_time, DATA_FILES(i));
            
        titulo = msprintf("Histograma: %s", DATA_FILES(i));
        plot_and_save_histogram(i + 100, diff_time, media, desvpad, titulo);
        
        hpa_data = read_csv(HPA_FILES(i));
        cpu_load = strtod(hpa_data(:,1));
        pod_number = strtod(hpa_data(:,2));
        time_mark = datetime(hpa_data(:,4));
        plot_and_save_sendXrec(i+200, send_time, rec_time, time_mark, pod_number, cpu_load, DATA_FILES(i) + " - sendXrec");
        
        sleep(50)
        disp("================================================================");
    end
    
end

