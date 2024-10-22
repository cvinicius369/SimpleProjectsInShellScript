# So pra ficar bonitin
bannerGeral(){
    echo "-----------------------------------"
    echo "        S Y S T E M A U X          "
    echo "-----------------------------------"
}
bannerScanner(){
    echo "-----------------------------------"
    echo "   N E T W O R K - S C A N N E R   "
    echo "-----------------------------------"
}
bannerClear(){
    echo "-----------------------------------"
    echo "      S Y S T E M - C L E A T      "
    echo "-----------------------------------"
}
# funcoes de limpeza e otimização
limpa_cache(){
    echo "Limpando cache do sistema..." | tee -a "$1"
    sudo apt clean
    sudo rm -rf "$2"/*
    echo "Cache do sistema limpo." | tee -a "$1"
    echo "" >> "$1"
}
limpa_temp() {
    echo "Limpando arquivos temporários..." | tee -a "$1"
    sudo rm -rf "$2"/*
    echo "Arquivos temporários limpos." | tee -a "$1"
    echo "" >> "$1"
}
limpa_logs() {
    echo "Limpando logs antigos..." | tee -a "$1"
    sudo find "$2" -type f -name "*.log" -exec truncate -s 0 {} \;
    sudo rm -rf "$2"/*.gz
    echo "Logs antigos limpos." | tee -a "$1"
    echo "" >> "$1"
}
limpa_packs() {
    echo "Removendo pacotes não utilizados..." | tee -a "$1"
    sudo apt autoremove -y
    sudo apt autoclean
    echo "Pacotes obsoletos removidos." | tee -a "$1"
    echo "" >> "$1"
}
update_system() {
    echo "Atualizando o sistema..." | tee -a "$1"
    sudo apt update && sudo apt upgrade -y
    echo "Sistema atualizado." | tee -a "$1"
    echo "" >> "$1"
}
# separa a funcao que gera o relatorio de scaneamento de rede
geraRelatorioScanner(){
    echo "Relatorio de Rede - $(date)" > "$1"
    echo "-----------------------------------" > "$1"
    echo "" > "$1"

    echo "Iniciando scanner na faixa $2 . . ."
    nmap -sn "$2" > tmp_ips.txt

    echo "Dispositivos ativos na rede: " >> "$1"
    grep "Nmap scan report for " tmp_ips.txt | awk '{print $5}' >> "$1"
    echo "" >> "$1"

    echo "Escaneando portas abertas dos dispositivos encontrados . . ."
    echo "Portas abertas por dispositivo: " >> "$1"

    while IFS= read -r IP; do
        echo "Escaneando $IP . . ."
        echo "Relatorio de portas abertas para $IP: " >> "$1"
        nmap -p- "$IP" | grep "open" >> "$1"
        echo "" >> "$1"
    done < <(grep "Nmap scan report for" tmp_ips.txt | awk '{print 5}')

    rm tmp_ips.txt # deletando dados temporarios
}
geraRelatorioClear(){
    echo "-------------------------------------" > "$1"
    echo "Relatório de Limpeza e Otimização - $(date)" >> "$1"
    echo "-------------------------------------" >> "$1"
    echo "" >> "$1"

    limpa_cache $1 $2
    limpa_logs $1 $3
    limpa_temp $1 $4
    limpa_packs

    echo "Limpeza e otimização concluídas." | tee -a "$1"
}
# a classica funcao main
main(){
    bannerGeral
    echo "[1] - Scanner   | [2] - System Clear   | [3] - Quit"
    read -p "-> " decision

    if [ "$decision" = "1" ]; then
        bannerScanner
        read -p "Digite o ip da rede: " rede
        relatorio="Relatorio_Rede$(date +%F_%T).txt"
        echo "Lembrando que voce precisa ter o nmap em sua maquina ;)"
        geraRelatorioScanner $relatorio $rede
        echo "Scanner finalizado e relatorio gerado"
    elif [ "$decision" = "2" ]; then
        bannerClear
        limp_cache="var/cache"
        limp_log="var/log"
        limp_temp="vat/tmp"
        limp_atp="var/lib/apt/lists"
        relatorio="Relatorio_Limpeza_$(date +%F_%T).txt"
        geraRelatorioClear $relatorio $limp_cache $limp_log $limp_temp $limp_atp
         echo "Relatório salvo em: $relatorio"
    else
        echo "Saindo . . . "
}
main