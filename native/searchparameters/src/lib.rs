#[macro_use]
extern crate rustler;

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
    let string: String = args[0].decode()?;

    Ok((atoms::ok(), string).encode(env))
}
