module integer_mate::full_math_u128 {
    use integer_mate::u256;
    use integer_mate::math_u128;

    public fun mul_div_floor(num1: u128, num2: u128, denom: u128): u128 {
        let r = u256::div(full_mul(num1, num2), u256::from(denom));
        (u256::as_u128(r))
    }
    
    public fun mul_div_round(num1: u128, num2: u128, denom: u128): u128 {
        let r = u256::div(u256::add(full_mul(num1, num2), u256::shr(u256::from(denom), 1)), u256::from(denom));
        (u256::as_u128(r))
    }
    
    public fun mul_div_ceil(num1: u128, num2: u128, denom: u128): u128 {
        let r = u256::div(u256::add(full_mul(num1, num2), u256::sub(u256::from(denom), u256::from(1))), u256::from(denom));
        (u256::as_u128(r))
    }
    
    public fun mul_shr(num1: u128, num2: u128, shift: u8): u128 {
      let product = u256::shr(full_mul(num1, num2), shift);
      (u256::as_u128(product))
    }
    
    public fun mul_shl(num1: u128, num2: u128, shift: u8): u128 {
      let product = u256::shl(full_mul(num1, num2), shift);
      (u256::as_u128(product))
    }

    public fun full_mul(num1: u128, num2: u128): u256::U256 {
        let (lo, hi) = math_u128::full_mul(num1, num2);
        u256::new(
            math_u128::lo(lo),
            math_u128::hi(lo),
            math_u128::lo(hi),
            math_u128::hi(hi),
        )
    }
}
