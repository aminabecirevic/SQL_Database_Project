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
			SELECT ('Greška: Nedovoljno zaliha za stavke u narudžbi. ') AS Message
			RETURN;
		END

	BEGIN TRY
		--izmjena statusa
		UPDATE dbo.Orders
		SET Status = 'Potvrðena'
		WHERE OrderID = @OrderID;
		IF @@ROWCOUNT <> 1
			SELECT ('Greška: Narudžba sa datim ID-em ne postoji. ') AS Message

	END TRY
	BEGIN CATCH
		SELECT ('Došlo je do greške prilikom potvrde narudžbe. ') AS Message
	END CATCH;
END;

