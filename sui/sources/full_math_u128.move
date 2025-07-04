module integer_mate::full_math_u128 {
    public fun mul_div_floor(num1: u128, num2: u128, denom: u128): u128 {
        let r = full_mul(num1, num2) / (denom as u256);
        (r as u128)
    }

    public fun mul_div_round(num1: u128, num2: u128, denom: u128): u128 {
        let r = (full_mul(num1, num2) + ((denom as u256) >> 1)) / (denom as u256);
        (r as u128)
    }

    public fun mul_div_ceil(num1: u128, num2: u128, denom: u128): u128 {
        let r = (full_mul(num1, num2) + ((denom as u256) - 1)) / (denom as u256);
        (r as u128)
    }

    public fun mul_shr(num1: u128, num2: u128, shift: u8): u128 {
        let product = full_mul(num1, num2) >> shift;
        (product as u128)
    }


    #[
        deprecated(
            note = b"This function converts num1 and num2 to u256, multiplies them, then left-shifts the result by the specified number of bits, and finally coerces the result into u128. The left shift does not perform overflow checks, so it is recommended not to use this function to avoid unexpected results.",
        ),
    ]
    public fun mul_shl(num1: u128, num2: u128, shift: u8): u128 {
        let product = full_mul(num1, num2) << shift;
        (product as u128)
    }

    public fun full_mul(num1: u128, num2: u128): u256 {
        (num1 as u256) * (num2 as u256)
    }
}
