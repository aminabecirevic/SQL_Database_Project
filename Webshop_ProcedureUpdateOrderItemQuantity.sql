CREATE PROCEDURE dbo.uspUpdateOrderItemQuantity
    @OrderItemID INT,
    @NewQuantity INT,
	@MaxQuantity INT
AS
BEGIN
    SET NOCOUNT ON;
	--provjera
        IF @NewQuantity <= 0
        BEGIN
            SELECT 'Greška: Kolièina mora biti veæa od nule.' AS Message;
            RETURN;
        END

		IF @NewQuantity > @MaxQuantity
		BEGIN
			SELECT 'Greška: Tražena kolièina prelazi raspoloživu kolièinu na stanju.' AS Message;
			RETURN;
		END
    BEGIN TRY
		--Izmjena kolièine
        UPDATE dbo.OrderItem
        SET Quantity = @NewQuantity
        WHERE OrderItemID = @OrderItemID;

    END TRY
    BEGIN CATCH
        --Ako doðe do greške, ispisat æe se poruka
        SELECT 'Došlo je do greške prilikom izmjene kolièine. ' AS Message;
    END CATCH;
END;
