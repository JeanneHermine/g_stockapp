create or replace function adjust_stock(product_id uuid, delta int)
returns void language plpgsql as $$
begin
  update products set stock = stock + delta where id = product_id;
end;
$$;
