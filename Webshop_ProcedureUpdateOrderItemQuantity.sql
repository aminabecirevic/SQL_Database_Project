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
            SELECT 'Gre�ka: Koli�ina mora biti ve�a od nule.' AS Message;
            RETURN;
        END

		IF @NewQuantity > @MaxQuantity
		BEGIN
			SELECT 'Gre�ka: Tra�ena koli�ina prelazi raspolo�ivu koli�inu na stanju.' AS Message;
			RETURN;
		END
    BEGIN TRY
		--Izmjena koli�ine
        UPDATE dbo.OrderItem
        SET Quantity = @NewQuantity
        WHERE OrderItemID = @OrderItemID;

    END TRY
    BEGIN CATCH
        --Ako do�e do gre�ke, ispisat �e se poruka
        SELECT 'Do�lo je do gre�ke prilikom izmjene koli�ine. ' AS Message;
    END CATCH;
END;
