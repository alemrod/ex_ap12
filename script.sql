--1.3 Escreva blocos anônimos para testar cada função
DO $$
DECLARE
    v_saldo NUMERIC;
BEGIN
    v_saldo := fn_consultar_saldo(2, 2);
    IF v_saldo IS NOT NULL THEN
        RAISE NOTICE 'Saldo da conta 1 do cliente 1: %', v_saldo;
    ELSE
        RAISE NOTICE 'Conta 1 do cliente 1 não encontrada.';
    END IF;
END;
$$

DO $$
DECLARE
    v_result BOOLEAN;
	p_cod_cliente_remetente INT;
    p_cod_conta_remetente INT;
    p_cod_cliente_destinatario INT;
    p_cod_conta_destinatario INT;
    p_valor_transferencia NUMERIC;
BEGIN
	p_cod_cliente_remetente := 1;
    p_cod_conta_remetente := 1;
    p_cod_cliente_destinatario := 2 ;
    p_cod_conta_destinatario := 2;
    p_valor_transferencia := 200;
    SELECT fn_transferir(p_cod_cliente_remetente, p_cod_conta_remetente, p_cod_cliente_destinatario, p_cod_conta_destinatario, p_valor_transferencia) INTO v_result;

    IF v_result THEN
        RAISE NOTICE 'Transfer successful!';
    ELSE
        RAISE NOTICE 'Transfer failed.';
    END IF;
END;
$$