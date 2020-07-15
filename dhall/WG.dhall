let Prelude = ./Prelude.dhall

let Colour = { red : Double, green : Double, blue : Double, alpha : Double }

let Vec2 = { x : Natural, y : Natural }

let Button = < Circle : Natural | Rectangle : Vec2 >

let Element =
      λ(a : Type) →
      λ(b : Type) →
        < Button : { button : Button, colour : Colour, buttonData : b }
        | Stick :
            { radius : Natural
            , range : Natural
            , stickColour : Colour
            , backgroundColour : Colour
            , stickDataX : a
            , stickDataY : a
            }
        >

let FullElement =
      λ(a : Type) →
      λ(b : Type) →
        { element : Element a b, location : Vec2, name : Text, showName : Bool }

let Layout =
      λ(a : Type) →
      λ(b : Type) →
        { elements : List (FullElement a b), grid : Vec2 }

let col =
      λ(r : Double) →
      λ(g : Double) →
      λ(b : Double) →
      λ(a : Double) →
        { red = r, green = g, blue = b, alpha = a }

let cols =
      { red = col 0.85 0.28 0.28 1.0
      , green = col 0.20 0.72 0.20 1.0
      , blue = col 0.28 0.28 0.85 1.0
      , yellow = col 0.94 0.95 0.33 1.0
      , black = col 0.0 0.0 0.0 1.0
      , white = col 1.0 1.0 1.0 1.0
      }

let voidLayout
    : ∀(a : Type) → ∀(b : Type) → Layout a b → Layout {} {}
    = λ(a : Type) →
      λ(b : Type) →
      λ(e : Layout a b) →
          e
        ⫽ { elements =
              Prelude.List.map
                (FullElement a b)
                (FullElement {} {})
                ( λ(fe : FullElement a b) →
                      fe
                    ⫽ { element =
                          merge
                            { Button =
                                λ ( b
                                  : { button : Button
                                    , colour : Colour
                                    , buttonData : b
                                    }
                                  ) →
                                  (Element {} {}).Button
                                    (b ⫽ { buttonData = {=} })
                            , Stick =
                                λ ( s
                                  : { radius : Natural
                                    , range : Natural
                                    , stickColour : Colour
                                    , backgroundColour : Colour
                                    , stickDataX : a
                                    , stickDataY : a
                                    }
                                  ) →
                                  (Element {} {}).Stick
                                    (s ⫽ { stickDataX = {=}, stickDataY = {=} })
                            }
                            fe.element
                      }
                )
                e.elements
          }

in  λ(a : Type) →
    λ(b : Type) →
      { Colour
      , Vec2
      , Button
      , Element = Element a b
      , FullElement = FullElement a b
      , Layout = Layout a b
      , cols
      , voidLayout = voidLayout a b
      }
