module csv

import strconv

pub fn decode<T>(data string) []T {

    mut parser := csv.new_reader( data )
    mut columns_names := []string{}
	mut result := []T{}
    mut i := 0
    for {
        items := parser.read() or { break }
            if i == 0 {
                for val in items {
                    columns_names << val
                }
            }
            else{
                mut t_val := T{}
                $for field in T.fields {
                    col := get_column( field.name, columns_names )
                    if col > -1 && col < items.len {
                        $if field.typ is string {
                            t_val.$(field.name) = items[col]
                        }
                        $else $if field.typ is int {
                            t_val.$(field.name) = items[col].int()
                        }
                        $else $if field.typ is f32 {
                            t_val.$(field.name) = f32(strconv.atof64( items[col] ) or { f32(0.0) })
                        }
                        $else $if field.typ is f64 {
                            t_val.$(field.name) = strconv.atof64( items[col] ) or { f64(0.0) }
                        }
                    }
                }
                result << t_val
            }
        i++
    }

    return result
}

fn get_column( name string, columns []string) int{
    for i, val in columns {
        if val == name {
            return i
        }
    }
    return -1
}