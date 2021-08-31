USE [dbGeoInterf]
GO
/****** Object:  StoredProcedure [dbo].[sp_reporte_eanes_productos_inactivos]    Script Date: 30/8/2021 18:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE sp_mail 

AS
BEGIN

SET NOCOUNT ON;
		declare @acumular NVARCHAR(MAX)
		declare @fecha varchar(10)

		set @fecha = CONVERT(VARCHAR(10), GETDATE(), 120)
	
		SET @acumular = '<style type="text/css">
				#box-table
				{
				font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
				font-size: 10px;
				text-align: center;
				border-collapse: collapse;
				border-top: 7px solid #A0C1E9;
				border-bottom: 7px solid #A0C1E9;
				}
				#box-table th
				{
				font-size: 12px;
				font-weight: normal;
				background: #B8D6FA;
				border-right: 2px solid #A0C1E9;
				border-left: 2px solid #A0C1E9;
				border-bottom: 2px solid #A0C1E9;
				color: #039;
				}
				#box-table td
				{
				border-right: 2px solid #aabcfe;
				border-left: 2px solid #aabcfe;
				border-bottom: 2px solid #aabcfe;
				color: #000000;
				}
				tr:nth-child(odd) { background-color:#fff; }
				tr:nth-child(even) { background-color:#fff; }
				</style><h3><font color="DarkSlateGray"> Productos Inactivos - Fecha: '+ @fecha +' </h3>
				<table id="box-table">
					<tr><font color="darkblue">
						<th style="width:130px">   Codigo  </th>
						<th style="width:200px">   Descripcion  </th>
					</tr>';

begin------------------------------------------INICIO DEL CURSOR
						DECLARE	@id varchar(16), @nombre varchar(60)
						DECLARE c_cursor CURSOR 
						FOR SELECT id, nombre from Sucursales order by id
						OPEN c_cursor
						FETCH NEXT FROM c_cursor INTO @id, @nombre
						WHILE @@fetch_status = 0
						BEGIN
							set @acumular = @acumular+'<tr><td>'+@id+'</td><td>'+@nombre+'</td></tr>'
							FETCH NEXT FROM c_cursor INTO @id, @nombre
						END
						CLOSE c_cursor
						DEALLOCATE c_cursor	
end------------------------------------------fin DEL CURSOR

 SET @acumular = @acumular + '</table>';
END

begin

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = N'mailprofile',
		@recipients = N'Wilson-Miltos@ajvierci.com.py',   
 
		@body_format = 'HTML',
		@body = @acumular,
		@subject = 'Prueba' ;
		select 1;

end
GO
