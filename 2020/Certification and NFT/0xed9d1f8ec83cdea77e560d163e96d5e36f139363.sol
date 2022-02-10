['/*\n', '\n', ' This contract is provided "as is" and "with all faults." The deployer makes no representations or warranties\n', ' of any kind concerning the safety, suitability, lack of exploits, inaccuracies, typographical errors, or other\n', ' harmful components of this contract. There are inherent dangers in the use of any contract, and you are solely\n', ' responsible for determining whether this contract is safe to use. You are also solely responsible for the \n', ' protection of your funds, and the deployer will not be liable for any damages you may suffer in connection with\n', ' using, modifying, or distributing this contract.\n', '\n', '*/\n', '\n', 'pragma solidity ^0.5.17;\n', '\n', '// From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol\n', '// Subject to the MIT license.\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        require(c >= a, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot underflow.\n', '     */\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        return sub(a, b, "::SafeMath: subtraction underflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot underflow.\n', '     */\n', '    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b <= a, errorMessage);\n', '        uint c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint c = a * b;\n', '        require(c / a == b, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers.\n', '     * Reverts on division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers.\n', '     * Reverts with custom message on division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint a, uint b) internal pure returns (uint) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface UniswapPair {\n', '    function sync() external;\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '    function mint(address to) external returns (uint liquidity);\n', '}\n', '\n', 'interface IBondingCurve {\n', '    function calculatePurchaseReturn(uint _supply,  uint _reserveBalance, uint32 _reserveRatio, uint _depositAmount) external view returns (uint);\n', '}\n', '\n', 'interface WETH9 {\n', '    function deposit() external payable;\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address recipient, uint amount) external returns (bool);\n', '    function approve(address spender, uint amount) external returns (bool);\n', '}\n', '\n', 'interface Uniswap {\n', '    function factory() external pure returns (address);\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '}\n', '\n', 'interface Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '}\n', '\n', 'interface LBI {\n', '    function approve(address spender, uint amount) external returns (bool);\n', '}\n', '\n', 'interface RewardDistributionDelegate {\n', '    function notifyRewardAmount(uint reward) external;\n', '}\n', '\n', 'interface RewardDistributionFactory {\n', '    function deploy(\n', '        address lp_, \n', '        address earn_, \n', '        address rewardDistribution_,\n', '        uint8 decimals_,\n', '        string calldata name_,\n', '        string calldata symbol_\n', '    ) external returns (address);\n', '}\n', '\n', 'interface GovernanceFactory {\n', '    function deploy(address token) external returns (address);\n', '}\n', '\n', 'contract LiquidityToken {\n', '    using SafeMath for uint;\n', '    \n', '    /* BondingCurve */\n', '    \n', '    uint public scale = 10**18;\n', '    uint public reserveBalance = 1*10**14;\n', '    uint32 public constant RATIO = 500000;\n', '    \n', '    WETH9 constant public WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    \n', '    function () external payable { mint(0); }\n', '    \n', '    mapping(address => uint) public bought;\n', '    mapping(address => uint) public price;\n', '    \n', '    function mint(uint min) public payable {\n', '        require(msg.value > 0, "::mint: msg.value = 0");\n', '        uint _weth = msg.value;\n', '        uint _bought = _continuousMint(_weth);\n', '        require(_bought >= min, "::mint: slippage");\n', '        WETH.deposit.value(_weth)();\n', '        if (fee > 0) {\n', '            uint _fee = _weth.mul(fee).div(FEEBASE);\n', '            WETH.transfer(governance, _fee);\n', '            _weth = _weth.sub(_fee);\n', '        }\n', '        price[msg.sender] = price[msg.sender].add(_weth);\n', '        bought[msg.sender] = bought[msg.sender].add(_bought);\n', '        _mint(msg.sender, _bought, true);\n', '    }\n', '    \n', '    function cancelStopLoss() external {\n', '        _commit(msg.sender, 0);\n', '    }\n', '    \n', '    function _commit(address from, uint balance) internal {\n', '        if (balance < bought[from]) {\n', '            bought[from] = 0;\n', '            WETH.transfer(address(pool), price[from]);\n', '            pool.sync();\n', '            price[from] = 0;\n', '        }\n', '    }\n', '    \n', '    function burn() public {\n', '        require(balances[msg.sender] >= bought[msg.sender], "::burn: insufficient burn quantity");\n', '        require(bought[msg.sender] >= 0, "::burn: no eligible tokens");\n', '        _burn(msg.sender, bought[msg.sender], true);\n', '        WETH.transfer(msg.sender, price[msg.sender]);\n', '    }\n', '    \n', '    IBondingCurve constant public CURVE = IBondingCurve(0x16F6664c16beDE5d70818654dEfef11769D40983);\n', '\n', '    function _buy(uint _amount) internal returns (uint _bought) {\n', '        _bought = _continuousMint(_amount);\n', '    }\n', '\n', '    function calculateMint(uint _amount) public view returns (uint mintAmount) {\n', '        return CURVE.calculatePurchaseReturn(totalSupply, reserveBalance, RATIO, _amount);\n', '    }\n', '\n', '    function _continuousMint(uint _deposit) internal returns (uint) {\n', '        uint amount = calculateMint(_deposit);\n', '        reserveBalance = reserveBalance.add(_deposit);\n', '        return amount;\n', '    }\n', '    \n', '    /// @notice EIP-20 token name for this token\n', '    string public name;\n', '\n', '    /// @notice EIP-20 token symbol for this token\n', '    string public symbol;\n', '\n', '    /// @notice EIP-20 token decimals for this token\n', '    uint8 public constant decimals = 18;\n', '    \n', '    /// @notice Total number of tokens in circulation\n', '    uint public totalSupply = 0; // Initial 0\n', '    \n', '    /// @notice the last block the tick was applied\n', '    uint public lastTick = 0;\n', '    \n', '    /// @notice the uniswap pool that will receive the rebase\n', '    UniswapPair public pool;\n', '    RewardDistributionDelegate public rewardDistribution;\n', '    RewardDistributionFactory public constant REWARDFACTORY = RewardDistributionFactory(0x323B2b67Ed1a745e5208ac18625ecef187a421D0);\n', '    GovernanceFactory public constant GOVERNANCEFACTORY = GovernanceFactory(0x4179Ef5dC359A4f73D5A14aF264f759052325bc1);\n', '    \n', '    /// @notice Allowance amounts on behalf of others\n', '    mapping (address => mapping (address => uint)) internal allowances;\n', '\n', '    /// @notice Official record of token balances for each account\n', '    mapping (address => uint) internal balances;\n', '\n', "    /// @notice The EIP-712 typehash for the contract's domain\n", '    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");\n', '\n', '    /// @notice The EIP-712 typehash for the permit struct used by the contract\n', '    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");\n', '\n', '    /// @notice A record of states for signing / validating signatures\n', '    mapping (address => uint) public nonces;\n', '\n', '    /// @notice The standard EIP-20 transfer event\n', '    event Transfer(address indexed from, address indexed to, uint amount);\n', '    \n', '    /// @notice Tick event\n', '    event Tick(uint block, uint minted);\n', '\n', '    /// @notice The standard EIP-20 approval event\n', '    event Approval(address indexed owner, address indexed spender, uint amount);\n', '    \n', '    Uniswap public constant UNI = Uniswap(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '    \n', '    /* Incremental system for balance increments */\n', '    uint256 public index = 0; // previously accumulated index\n', '    uint256 public bal = 0; // previous calculated balance of COMP\n', '\n', '    mapping(address => uint256) public supplyIndex;\n', '    \n', '    function _update(bool sync) internal {\n', '        if (totalSupply > 0) {\n', '            uint256 _before = balances[address(this)];\n', '            tick(sync);\n', '            uint256 _bal = balances[address(this)];\n', '            if (_bal > 0 && _bal > _before) {\n', '                uint256 _diff = _bal.sub(bal, "::_update: ball _diff");\n', '                if (_diff > 0) {\n', '                    uint256 _ratio = _diff.mul(1e18).div(totalSupply);\n', '                    if (_ratio > 0) {\n', '                      index = index.add(_ratio);\n', '                      bal = _bal;\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    mapping(address => uint) claimable;\n', '    \n', '    function claim() external {\n', '        claimFor(msg.sender);\n', '    }\n', '    function claimFor(address recipient) public {\n', '        _updateFor(recipient, true);\n', '        _transferTokens(address(this), recipient, claimable[recipient]);\n', '        claimable[recipient] = 0;\n', '        bal = balances[address(this)];\n', '    }\n', '    \n', '    function _updateFor(address recipient, bool sync) public {\n', '        _update(sync);\n', '        uint256 _supplied = balances[recipient];\n', '        if (_supplied > 0) {\n', '            uint256 _supplyIndex = supplyIndex[recipient];\n', '            supplyIndex[recipient] = index;\n', '            uint256 _delta = index.sub(_supplyIndex, "::_claimFor: index delta");\n', '            if (_delta > 0) {\n', '              uint256 _share = _supplied.mul(_delta).div(1e18);\n', '              claimable[recipient] = claimable[recipient].add(_share);\n', '            }\n', '        } else {\n', '            supplyIndex[recipient] = index;\n', '        }\n', '    }\n', '    \n', '    constructor(string memory name_, string memory symbol_, uint fee_) public {\n', '        require(fee <= 10000, "::(): fee > 100%");\n', '        lastTick = block.number;\n', '        name = name_;\n', '        symbol = symbol_;\n', '        fee = fee_;\n', '    }\n', '    \n', '    address public governance;\n', '    uint public fee;\n', '    uint public constant FEEBASE = 10000;\n', '    \n', '    function setup() external payable {\n', '        require(msg.value > 0, "LBT:(): constructor requires ETH");\n', '        require(address(pool) == address(0x0), "LBT:(): already initialized");\n', '        \n', '        _mint(address(this), 10000e18, true); // init total supply\n', '        WETH.deposit.value(msg.value)();\n', '        \n', '        _mint(address(this), _continuousMint(msg.value), true);\n', '        uint _balance = WETH.balanceOf(address(this));\n', '        require(_balance == msg.value, "LBT:(): WETH9 error");\n', '        WETH.approve(address(UNI), _balance);\n', '        allowances[address(this)][address(UNI)] = balances[address(this)];\n', '        require(allowances[address(this)][address(UNI)] == balances[address(this)], "LBT:(): address(this) error");\n', '        \n', '        UNI.addLiquidity(address(this), address(WETH), balances[address(this)], WETH.balanceOf(address(this)), 0, 0, msg.sender, now.add(1800));\n', '        pool = UniswapPair(Factory(UNI.factory()).getPair(address(this), address(WETH)));\n', '        rewardDistribution = RewardDistributionDelegate(REWARDFACTORY.deploy(address(pool), address(this), address(this), 18, "Liquidity Income Delegate", "LBD"));\n', '        _mint(address(this), 1e18, true);\n', '        allowances[address(this)][address(rewardDistribution)] = 1e18;\n', '        rewardDistribution.notifyRewardAmount(1e18);\n', '        governance = GOVERNANCEFACTORY.deploy(address(rewardDistribution));\n', '    }\n', '    \n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "::setGovernance: governance only");\n', '        governance = _governance;\n', '    }\n', '    \n', '    // TEST HELPER FUNCTION :: DO NOT USE\n', '    function removeLiquidityMax() public {\n', '        removeLiquidity(pool.balanceOf(msg.sender), 0, 0);\n', '    }\n', '    \n', '    // TEST HELPER FUNCTION :: DO NOT USE\n', '    function removeLiquidity(uint amountA, uint minA, uint minB) public {\n', '        tick(true);\n', '        pool.transferFrom(msg.sender, address(this), amountA);\n', '        pool.approve(address(UNI), amountA);\n', '        UNI.removeLiquidity(address(this), address(WETH), amountA, minA, minB, msg.sender, now.add(1800));\n', '    }\n', '    \n', '    // TEST HELPER FUNCTION :: DO NOT USE\n', '    function addLiquidityMax() public payable {\n', '        addLiquidity(balances[msg.sender]);\n', '    }\n', '    \n', '    // TEST HELPER FUNCTION :: DO NOT USE\n', '    function addLiquidity(uint amountA) public payable {\n', '        tick(true);\n', '        WETH.deposit.value(msg.value)();\n', '        WETH.transfer(address(pool), msg.value);\n', '        _transferTokens(msg.sender, address(pool), amountA);\n', '        pool.mint(msg.sender);\n', '    }\n', '    \n', '    function _mint(address dst, uint amount, bool sync) internal {\n', '        // mint the amount\n', '        totalSupply = totalSupply.add(amount);\n', '\n', '        _updateFor(dst, sync);\n', '        // transfer the amount to the recipient\n', '        balances[dst] = balances[dst].add(amount);\n', '        emit Transfer(address(0), dst, amount);\n', '    }\n', '    \n', '    function _burn(address dst, uint amount, bool sync) internal {\n', '        require(dst != address(0), "::_burn: burn from the zero address");\n', '        \n', '        _updateFor(dst, sync);\n', '        \n', '        balances[dst] = balances[dst].sub(amount, "::_burn: burn amount exceeds balance");\n', '        totalSupply = totalSupply.sub(amount);\n', '        emit Transfer(dst, address(0), amount);\n', '    }\n', '    \n', '    uint public LP = 9000;\n', '    uint public constant BASE = 10000;\n', '    uint public DURATION = 700000;\n', '    \n', '    address public timelock;\n', '    \n', '    function setDuration(uint duration_) external {\n', '        require(msg.sender == governance, "::setDuration only governance");\n', '        DURATION = duration_;\n', '    }\n', '    \n', '    function setRatio(uint lp_) external {\n', '        require(msg.sender == governance, "::setRatio only governance");\n', '        LP = lp_;\n', '    }\n', '    \n', '    /**\n', '     * @notice tick to increase holdings\n', '     */\n', '    function tick(bool sync) public {\n', '        uint _current = block.number;\n', '        uint _diff = _current.sub(lastTick);\n', '        \n', '        if (_diff > 0) {\n', '            lastTick = _current;\n', '            \n', '            _diff = balances[address(pool)].mul(_diff).div(DURATION); // 1% every 7000 blocks\n', '            uint _minting = _diff.div(2);\n', '            if (_minting > 0) {\n', '                _transferTokens(address(pool), address(this), _minting);\n', '                \n', "                // Can't call sync while in addLiquidity or removeLiquidity\n", '                if (sync) {\n', '                    pool.sync();\n', '                }\n', '                _mint(address(this), _minting, false);\n', '                // % of tokens that go to LPs\n', '                uint _lp = _diff.mul(LP).div(BASE);\n', '                allowances[address(this)][address(rewardDistribution)] = _lp;\n', '                rewardDistribution.notifyRewardAmount(_lp);\n', '                \n', '                emit Tick(_current, _diff);\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`\n', '     * @param account The address of the account holding the funds\n', '     * @param spender The address of the account spending the funds\n', '     * @return The number of tokens approved\n', '     */\n', '    function allowance(address account, address spender) external view returns (uint) {\n', '        return allowances[account][spender];\n', '    }\n', '\n', '    /**\n', '     * @notice Approve `spender` to transfer up to `amount` from `src`\n', '     * @dev This will overwrite the approval amount for `spender`\n', '     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)\n', '     * @param spender The address of the account which may transfer tokens\n', '     * @param amount The number of tokens that are approved (2^256-1 means infinite)\n', '     * @return Whether or not the approval succeeded\n', '     */\n', '    function approve(address spender, uint amount) public returns (bool) {\n', '        allowances[msg.sender][spender] = amount;\n', '\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Triggers an approval from owner to spends\n', '     * @param owner The address to approve from\n', '     * @param spender The address to be approved\n', '     * @param amount The number of tokens that are approved (2^256-1 means infinite)\n', '     * @param deadline The time at which to expire the signature\n', '     * @param v The recovery byte of the signature\n', '     * @param r Half of the ECDSA signature pair\n', '     * @param s Half of the ECDSA signature pair\n', '     */\n', '    function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {\n', '        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));\n', '        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));\n', '        bytes32 digest = keccak256(abi.encodePacked("\\x19\\x01", domainSeparator, structHash));\n', '        address signatory = ecrecover(digest, v, r, s);\n', '        require(signatory != address(0), "::permit: invalid signature");\n', '        require(signatory == owner, "::permit: unauthorized");\n', '        require(now <= deadline, "::permit: signature expired");\n', '\n', '        allowances[owner][spender] = amount;\n', '\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    /**\n', '     * @notice Get the number of tokens held by the `account`\n', '     * @param account The address of the account to get the balance of\n', '     * @return The number of tokens held\n', '     */\n', '    function balanceOf(address account) external view returns (uint) {\n', '        return balances[account];\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `msg.sender` to `dst`\n', '     * @param dst The address of the destination account\n', '     * @param amount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transfer(address dst, uint amount) public returns (bool) {\n', '        _transferTokens(msg.sender, dst, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfer `amount` tokens from `src` to `dst`\n', '     * @param src The address of the source account\n', '     * @param dst The address of the destination account\n', '     * @param amount The number of tokens to transfer\n', '     * @return Whether or not the transfer succeeded\n', '     */\n', '    function transferFrom(address src, address dst, uint amount) external returns (bool) {\n', '        address spender = msg.sender;\n', '        uint spenderAllowance = allowances[src][spender];\n', '\n', '        if (spender != src && spenderAllowance != uint(-1)) {\n', '            uint newAllowance = spenderAllowance.sub(amount, "::transferFrom: transfer amount exceeds spender allowance");\n', '            allowances[src][spender] = newAllowance;\n', '\n', '            emit Approval(src, spender, newAllowance);\n', '        }\n', '\n', '        _transferTokens(src, dst, amount);\n', '        return true;\n', '    }\n', '\n', '    function _transferTokens(address src, address dst, uint amount) internal {\n', '        require(src != address(0), "::_transferTokens: cannot transfer from the zero address");\n', '        require(dst != address(0), "::_transferTokens: cannot transfer to the zero address");\n', '        \n', '        bool sync = true;\n', '        if (src == address(pool) || dst == address(pool)) {\n', '            sync = false;\n', '        }\n', '        \n', '        _updateFor(src, sync);\n', '        _updateFor(dst, sync);\n', '        \n', '        balances[src] = balances[src].sub(amount, "::_transferTokens: transfer amount exceeds balance");\n', '        _commit(src, balances[src]);\n', '        balances[dst] = balances[dst].add(amount, "::_transferTokens: transfer amount overflows");\n', '        emit Transfer(src, dst, amount);\n', '    }\n', '\n', '    function getChainId() internal pure returns (uint) {\n', '        uint chainId;\n', '        assembly { chainId := chainid() }\n', '        return chainId;\n', '    }\n', '}\n', '\n', 'contract LiquidityTokenFactory {\n', '    function deploy(string calldata name, string calldata symbol, uint fee) external payable returns (address) {\n', '        LiquidityToken lbi = new LiquidityToken(name, symbol, fee);\n', '        lbi.setup.value(msg.value)();\n', '        return address(lbi);\n', '    }\n', '}']