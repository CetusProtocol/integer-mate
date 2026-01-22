module integer_mate::math_u256 {
    use integer_mate::math_u128::overflowing_add as overflowing_add_u128;
    const MAX_U256: u256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    const LO_128_MASK: u256 = 0xffffffffffffffffffffffffffffffff;

    public fun div_mod(num: u256, denom: u256): (u256, u256) {
        let p = num / denom;
        let r: u256 = num - (p * denom);
        (p, r)
    }

    public fun shlw(n: u256): u256 {
        n << 64
    }

    public fun shrw(n: u256): u256 {
        n >> 64
    }

    public fun checked_shlw(n: u256): (u256, bool) {
        let bound = 1 << 192;
        if (n >= bound) {
            (0, true)
        } else {
            ((n << 64), false)
        }
    }

    public fun div_round(num: u256, denom: u256, round_up: bool): u256 {
        let p = num / denom;
        if (round_up && ((p * denom) != num)) {
            p + 1
        } else {
            p
        }
    }

    public fun add_check(num1: u256, num2: u256): bool {
        (MAX_U256 - num1 >= num2)
    }

    public fun wrapping_sub(n1: u256, n2: u256): u256 {
        let (result, _) = overflowing_sub(n1, n2);
        result
    }
    
    public fun overflowing_sub(n1: u256, n2: u256): (u256, bool) {
        if (n1 >= n2) {
            ((n1 - n2), false)
        } else {
            ((std::u256::max_value!() - n2 + n1 + 1), true)
        }
    }

    /// Wrapping addition for u256 - discards overflow
    public fun wrapping_add(n1: u256, n2: u256): u256 {
        let (sum, _) = overflowing_add(n1, n2);
        sum
    }

    /// Overflowing addition for u256 - returns (sum, overflow_flag)
    public fun overflowing_add(n1: u256, n2: u256): (u256, bool) {
        // Split each u256 into high and low u128 parts
        let n1_lo = (n1 & LO_128_MASK) as u128;
        let n1_hi = ((n1 >> 128) & LO_128_MASK) as u128;
        let n2_lo = (n2 & LO_128_MASK) as u128;
        let n2_hi = ((n2 >> 128) & LO_128_MASK) as u128;

        // Add low parts with overflow detection
        let (lo_sum, lo_carry) = overflowing_add_u128(n1_lo, n2_lo);

        // Add high parts with carry from low addition
        let (hi_sum_no_carry, hi_overflow1) = overflowing_add_u128(n1_hi, n2_hi);
        let (hi_sum, hi_overflow2) = overflowing_add_u128(hi_sum_no_carry, if (lo_carry) 1u128 else 0u128);

        // Combine high and low parts
        let result = ((hi_sum as u256) << 128) | (lo_sum as u256);

        // Overflow occurred if either high addition overflowed
        (result, hi_overflow1 || hi_overflow2)
    }
}
