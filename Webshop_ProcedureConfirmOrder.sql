CREATE PROCEDURE dbo.uspConfirmOrder
	@OrderID INT
AS
BEGIN 
	SET NOCOUNT ON
		--provjera zaliha
		IF EXISTS (
			SELECT 1
			FROM dbo.OrderItem oi
			JOIN dbo.Product p ON oi.ProductID = p.ProductID
			WHERE oi.OrderID = @OrderID AND oi.Quantity > p.Stock
		)
		BEGIN
			SELECT ('Gre�ka: Nedovoljno zaliha za stavke u narud�bi. ') AS Message
			RETURN;
		END

	BEGIN TRY
		--izmjena statusa
		UPDATE dbo.Orders
		SET Status = 'Potvr�ena'
		WHERE OrderID = @OrderID;
		IF @@ROWCOUNT <> 1
			SELECT ('Gre�ka: Narud�ba sa datim ID-em ne postoji. ') AS Message

	END TRY
	BEGIN CATCH
		SELECT ('Do�lo je do gre�ke prilikom potvrde narud�be. ') AS Message
	END CATCH;
END;

