#[macro_use]
extern crate rustler;

use regex::Regex;
use rustler::{Encoder, Env, Error, Term};

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Exzeitable.SearchParameters",
    [
        ("convert", 1, convert)
    ],
    None
}

fn convert<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let mut string: String = args[0].decode()?;

    remove_special_characters(&mut string);
    build_query(&mut string);

    Ok((atoms::ok(), string).encode(env))
}

fn remove_special_characters(s: &mut String) -> String {
    let non_word_characters = Regex::new(r"[^A-Za-z0-9\s]").unwrap();

    non_word_characters.replace_all(&s, "").to_string()
}

fn build_query(s: &mut String) -> String {
    let string_list: Vec<&str> = s.split_whitespace().collect();
    let mut counter = 0;
    let length = string_list.len();
    let mut result = String::new();

    loop {
        if counter < length - 1 {
            result.push_str(string_list[counter]);
            result.push_str(":* & ");
            counter += 1;
        } else {
            result.push_str(string_list[counter]);
            result.push_str(":*");
            break;
        }
    }

    result
}
