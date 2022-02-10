['pragma solidity ^0.4.13;\n', '\n', 'library safeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    uint c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '}\n', '\n', 'contract DBC {\n', '\n', '    // MODIFIERS\n', '\n', '    modifier pre_cond(bool condition) {\n', '        require(condition);\n', '        _;\n', '    }\n', '\n', '    modifier post_cond(bool condition) {\n', '        _;\n', '        assert(condition);\n', '    }\n', '\n', '    modifier invariant(bool condition) {\n', '        require(condition);\n', '        _;\n', '        assert(condition);\n', '    }\n', '}\n', '\n', 'contract ERC20Interface {\n', '\n', '    // EVENTS\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // CONSTANT METHODS\n', '\n', '    function totalSupply() constant returns (uint256 totalSupply) {}\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {}\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}\n', '\n', '    // NON-CONSTANT METHODS\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}\n', '    function approve(address _spender, uint256 _value) returns (bool success) {}\n', '}\n', '\n', 'contract ERC20 is ERC20Interface {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { throw; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { throw; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263555598\n', '        if (_value > 0) {\n', '            require(allowed[msg.sender][_spender] == 0);\n', '        }\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    uint256 public totalSupply;\n', '\n', '}\n', '\n', 'contract Vesting is DBC {\n', '    using safeMath for uint;\n', '\n', '    // FIELDS\n', '\n', '    // Constructor fields\n', '    ERC20 public MELON_CONTRACT; // Melon as ERC20 contract\n', '    // Methods fields\n', '    uint public totalVestedAmount; // Quantity of vested Melon in total\n', '    uint public vestingStartTime; // Timestamp when vesting is set\n', '    uint public vestingPeriod; // Total vesting period in seconds\n', '    address public beneficiary; // Address of the beneficiary\n', '    uint public withdrawn; // Quantity of Melon withdrawn so far\n', '\n', '    // CONSTANT METHODS\n', '\n', '    function isBeneficiary() constant returns (bool) { return msg.sender == beneficiary; }\n', '    function isVestingStarted() constant returns (bool) { return vestingStartTime != 0; }\n', '\n', "    /// @notice Calculates the quantity of Melon asset that's currently withdrawable\n", '    /// @return withdrawable Quantity of withdrawable Melon asset\n', '    function calculateWithdrawable() constant returns (uint withdrawable) {\n', '        uint timePassed = now.sub(vestingStartTime);\n', '\n', '        if (timePassed < vestingPeriod) {\n', '            uint vested = totalVestedAmount.mul(timePassed).div(vestingPeriod);\n', '            withdrawable = vested.sub(withdrawn);\n', '        } else {\n', '            withdrawable = totalVestedAmount.sub(withdrawn);\n', '        }\n', '    }\n', '\n', '    // NON-CONSTANT METHODS\n', '\n', '    /// @param ofMelonAsset Address of Melon asset\n', '    function Vesting(address ofMelonAsset) {\n', '        MELON_CONTRACT = ERC20(ofMelonAsset);\n', '    }\n', '\n', '    /// @param ofBeneficiary Address of beneficiary\n', '    /// @param ofMelonQuantity Address of Melon asset\n', '    /// @param ofVestingPeriod Vesting period in seconds from vestingStartTime\n', '    function setVesting(address ofBeneficiary, uint ofMelonQuantity, uint ofVestingPeriod)\n', '        pre_cond(!isVestingStarted())\n', '        pre_cond(ofMelonQuantity > 0)\n', '    {\n', '        require(MELON_CONTRACT.transferFrom(msg.sender, this, ofMelonQuantity));\n', '        vestingStartTime = now;\n', '        totalVestedAmount = ofMelonQuantity;\n', '        vestingPeriod = ofVestingPeriod;\n', '        beneficiary = ofBeneficiary;\n', '    }\n', '\n', '    /// @notice Withdraw\n', '    function withdraw()\n', '        pre_cond(isBeneficiary())\n', '        pre_cond(isVestingStarted())\n', '    {\n', '        uint withdrawable = calculateWithdrawable();\n', '        withdrawn = withdrawn.add(withdrawable);\n', '        require(MELON_CONTRACT.transfer(beneficiary, withdrawable));\n', '    }\n', '\n', '}']