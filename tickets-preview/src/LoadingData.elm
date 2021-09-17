module LoadingData exposing (..)


type LoadingData a
    = Loading
    | Error
    | Success a
