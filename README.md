animated-ui-label
=================

Animation makes it easier to understand changes that happen to data. When showing data as text
there is no general way to animate changes and things like cross-fade are not very helpful.

Sometimes text conveys data such as amounts, speed, weight that can be animated in a meaningful
way by interpolating between these amounts, speeds or weights.

This UILabel subclass tries to help in these circumstances by splitting text text into a leading
number and a trailer, such that a text

    "100 apples" 
is really 100.0 and " apples" and if we need to change the text into 

    "300 apples"
then we are really animating between 100.0 and 300.0 with a shared trailing text " apples".

<img src="example.gif"/>

If these assumptions are not met, the text will be changed without animation.
You just need the AnimatedLabel.h/m as everything else is just for testing purposes.

AnimatedLabel is made to allow other kinds of text interpolations. You override

    -(id)animationContextFrom:(NSString*)sourceText to:(NSString*)targetText;
to make the logic that determines whether animation is possible at all and to
perform any precalculations that would be used when calculating the interpolated
text (which will be done many times). You return nil when there should be no animation
and otherwise any object that suits you.

To calculate the actual text you override

    -(NSString*)textAtRatio:(CGFloat)ratio context:(id)context
                      from:(NSString*)sourceText to:(NSString*)targetText;
where ratio starts at 0.0 and ends at 1.0.
