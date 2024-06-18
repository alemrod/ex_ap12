-- 1.2
-- Escreva a seguinte função
-- nome: fn_transferir
-- recebe: código de cliente remetente, código de conta remetente, código de cliente
-- destinatário, código de conta destinatário, valor da transferência
-- devolve: um booleano que indica se a transferência ocorreu ou não. Uma transferência
-- somente pode acontecer se nenhuma conta envolvida ficar no negativo.
DROP ROUTINE IF EXISTS fn_transferir;
CREATE OR REPLACE FUNCTION fn_transferir(
    p_cod_cliente_remetente INT,
    p_cod_conta_remetente INT,
    p_cod_cliente_destinatario INT,
    p_cod_conta_destinatario INT,
    p_valor_transferencia NUMERIC
)RETURNS BOOLEAN 
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo_remetente NUMERIC;
    v_saldo_destinatario NUMERIC;
    v_status_remetente VARCHAR(200);
    v_status_destinatario VARCHAR(200);
BEGIN
    SELECT saldo, status INTO v_saldo_remetente, v_status_remetente
    FROM tb_conta
    WHERE cod_cliente = p_cod_cliente_remetente AND cod_conta = p_cod_conta_remetente;

    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;
    SELECT saldo, status INTO v_saldo_destinatario, v_status_destinatario
    FROM tb_conta
    WHERE cod_cliente = p_cod_cliente_destinatario AND cod_conta = p_cod_conta_destinatario;

    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;
    IF v_status_remetente != 'aberta' OR v_status_destinatario != 'aberta' THEN
        RETURN FALSE;
    END IF;
    IF v_saldo_remetente < p_valor_transferencia THEN
        RETURN FALSE;
    END IF;
    UPDATE tb_conta
    SET saldo = saldo - p_valor_transferencia,
        data_ultima_transacao = CURRENT_TIMESTAMP
    WHERE cod_cliente = p_cod_cliente_remetente AND cod_conta = p_cod_conta_remetente;

    UPDATE tb_conta
    SET saldo = saldo + p_valor_transferencia,
        data_ultima_transacao = CURRENT_TIMESTAMP
    WHERE cod_cliente = p_cod_cliente_destinatario AND cod_conta = p_cod_conta_destinatario;
    RETURN TRUE;
END;
$$