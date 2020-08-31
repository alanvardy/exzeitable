#[macro_use]
extern crate rustler;

use reduce::Reduce;
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

    string = remove_special_characters(string);
    string = build_query(string);

    Ok((atoms::ok(), string).encode(env))
}

fn remove_special_characters(s: String) -> String {
    let non_word_characters = Regex::new(r"[^A-Za-z0-9\s]").unwrap();

    non_word_characters.replace_all(&s, "").to_string()
}

fn build_query(s: String) -> String {
    s.split_whitespace()
        .map(|x| format!("{}:*", x))
        .reduce(|acc, x| format!("{} & {}", acc, x))
        .unwrap()
}
