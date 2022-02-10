['pragma solidity 0.6.4;\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '//ERC20 Interface\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address, uint) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '    function approve(address, uint) external returns (bool);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    }\n', '    \n', 'interface ASP {\n', '    \n', '   function scaledToken(uint amount) external returns(bool);\n', '   function totalFrozen() external view returns (uint256);\n', ' }\n', '\n', 'interface OSP {\n', '    \n', '   function scaledToken(uint amount) external returns(bool);\n', '   function totalFrozen() external view returns (uint256);\n', ' }\n', ' \n', 'interface DSP {\n', '    \n', '   function scaledToken(uint amount) external returns(bool);\n', '   function totalFrozen() external view returns (uint256);\n', ' }\n', '\n', 'interface USP {\n', '    \n', '   function scaledToken(uint amount) external returns(bool);\n', '   function totalFrozen() external view returns (uint256);\n', ' }\n', '    \n', '//======================================AXIA CONTRACT=========================================//\n', 'contract AXIATOKEN is ERC20 {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '//======================================AXIA EVENTS=========================================//\n', '\n', '    event NewEpoch(uint epoch, uint emission, uint nextepoch);\n', '    event NewDay(uint epoch, uint day, uint nextday);\n', '    event BurnEvent(address indexed pool, address indexed burnaddress, uint amount);\n', '    event emissions(address indexed root, address indexed pool, uint value);\n', '    event TrigRewardEvent(address indexed root, address indexed receiver, uint value);\n', '    event BasisPointAdded(uint value);\n', '    \n', '    \n', '   // ERC-20 Parameters\n', '    string public name; \n', '    string public symbol;\n', '    uint public decimals; \n', '    uint public startdecimal;\n', '    uint public override totalSupply;\n', '    uint public initialsupply;\n', '    \n', '     //======================================STAKING POOLS=========================================//\n', '    \n', '    address public lonePool;\n', '    address public swapPool;\n', '    address public DefiPool;\n', '    address public OraclePool;\n', '    \n', '    address public burningPool;\n', '    \n', '    uint public pool1Amount;\n', '    uint public pool2Amount;\n', '    uint public pool3Amount;\n', '    uint public pool4Amount;\n', '    uint public poolAmountTrig;\n', '    \n', '    \n', '    uint public TrigAmount;\n', '    \n', '    \n', '    // ERC-20 Mappings\n', '    mapping(address => uint) public override balanceOf;\n', '    mapping(address => mapping(address => uint)) public override allowance;\n', '    \n', '    \n', '    // Public Parameters\n', '    uint crypto; \n', '    uint startcrypto;\n', '    uint public emission;\n', '    uint public currentEpoch; \n', '    uint public currentDay;\n', '    uint public daysPerEpoch; \n', '    uint public secondsPerDay;\n', '    uint public genesis;\n', '    uint public nextEpochTime; \n', '    uint public nextDayTime;\n', '    uint public amountToEmit;\n', '    uint public BPE;\n', '    \n', '    //======================================BASIS POINT VARIABLES=========================================//\n', '    uint public bpValue;\n', '    uint public actualValue;\n', '    uint public TrigReward;\n', '    uint public burnAmount;\n', '    address administrator;\n', '    uint totalEmitted;\n', '    \n', '    uint256 public pool1percentage = 3500;\n', '    uint256 public pool2percentage = 6500;\n', '    uint256 public pool3percentage = 0;\n', '    uint256 public pool4percentage = 0;\n', '    uint256 public trigRewardpercentage = 20;\n', '    \n', '    \n', '    address public messagesender;\n', '     \n', '    // Public Mappings\n', '    mapping(address=>bool) public Address_Whitelisted;\n', '    mapping(address=>bool) public emission_Whitelisted;\n', '    \n', '\n', '    //=====================================CREATION=========================================//\n', '    // Constructor\n', '    constructor() public {\n', '        name = "AXIA TOKEN (axiaprotocol.io)"; \n', '        symbol = "AXIA-V2"; \n', '        decimals = 18; \n', '        startdecimal = 16;\n', '        crypto = 1*10**decimals; \n', '        startcrypto =  1*10**startdecimal; \n', '        totalSupply = 3000000*crypto;                                 \n', '        initialsupply = 50203125*startcrypto;\n', '        emission = 7200*crypto; \n', '        currentEpoch = 1; \n', '        currentDay = 1;                             \n', '        genesis = now;\n', '        \n', '        daysPerEpoch = 180; \n', '        secondsPerDay = 86400; \n', '       \n', '        administrator = msg.sender;\n', '        balanceOf[administrator] = initialsupply; \n', '        emit Transfer(administrator, address(this), initialsupply);                                \n', '        nextEpochTime = genesis + (secondsPerDay * daysPerEpoch);                                   \n', '        nextDayTime = genesis + secondsPerDay;                                                      \n', '        \n', '        Address_Whitelisted[administrator] = true; \n', '        emission_Whitelisted[administrator] = true;\n', '        \n', '        \n', '        \n', '    }\n', '    \n', '//========================================CONFIGURATIONS=========================================//\n', '    \n', '    function poolconfigs(address _axia, address _swap, address _defi, address _oracle) public onlyAdministrator returns (bool success) {\n', '        \n', '        lonePool = _axia;\n', '        swapPool = _swap;\n', '        DefiPool = _defi;\n', '        OraclePool = _oracle;\n', '        \n', '        \n', '        \n', '        return true;\n', '    }\n', '    \n', '    function burningPoolconfigs(address _pooladdress) public onlyAdministrator returns (bool success) {\n', '           \n', '        burningPool = _pooladdress;\n', '        \n', '        return true;\n', '    }\n', '    \n', '    \n', '    modifier onlyAdministrator() {\n', '        require(msg.sender == administrator, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    modifier onlyBurningPool() {\n', '        require(msg.sender == burningPool, "Authorization: Only the pool that allows burn can call on this");\n', '        _;\n', '    }\n', '    \n', '    function whitelist(address _address) public onlyAdministrator returns (bool success) {\n', '       Address_Whitelisted[_address] = true;\n', '        return true;\n', '    }\n', '    \n', '    function unwhitelist(address _address) public onlyAdministrator returns (bool success) {\n', '       Address_Whitelisted[_address] = false;\n', '        return true;\n', '    }\n', '    \n', '    function secondAndDay(uint _secondsperday, uint _daysperepoch) public onlyAdministrator returns (bool success) {\n', '       secondsPerDay = _secondsperday;\n', '       daysPerEpoch = _daysperepoch;\n', '        return true;\n', '    }\n', '    \n', '    function nextEpoch(uint _nextepoch) public onlyAdministrator returns (bool success) {\n', '       nextEpochTime = _nextepoch;\n', '       \n', '        return true;\n', '    }\n', '    \n', '    function whitelistOnEmission(address _address) public onlyAdministrator returns (bool success) {\n', '       emission_Whitelisted[_address] = true;\n', '        return true;\n', '    }\n', '    \n', '    function unwhitelistOnEmission(address _address) public onlyAdministrator returns (bool success) {\n', '       emission_Whitelisted[_address] = false;\n', '        return true;\n', '    }\n', '    \n', '    \n', '    function supplyeffect(uint _amount) public onlyBurningPool returns (bool success) {\n', '       totalSupply -= _amount;\n', '       emit BurnEvent(burningPool, address(0x0), _amount);\n', '        return true;\n', '    }\n', '    \n', '    function poolpercentages(uint _p1, uint _p2, uint _p3, uint _p4, uint trigRe) public onlyAdministrator returns (bool success) {\n', '       \n', '       pool1percentage = _p1;\n', '       pool2percentage = _p2;\n', '       pool3percentage = _p3;\n', '       pool4percentage = _p4;\n', '       trigRewardpercentage = trigRe;\n', '       \n', '       return true;\n', '    }\n', '    \n', '    function Burn(uint _amount) public returns (bool success) {\n', '       \n', '       require(balanceOf[msg.sender] >= _amount, "You do not have the amount of tokens you wanna burn in your wallet");\n', '       balanceOf[msg.sender] -= _amount;\n', '       totalSupply -= _amount;\n', '       emit BurnEvent(msg.sender, address(0x0), _amount);\n', '       return true;\n', '       \n', '    }\n', '    \n', '   //========================================ERC20=========================================//\n', '    // ERC20 Transfer function\n', '    function transfer(address to, uint value) public override returns (bool success) {\n', '        _transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    // ERC20 Approve function\n', '    function approve(address spender, uint value) public override returns (bool success) {\n', '        allowance[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '    // ERC20 TransferFrom function\n', '    function transferFrom(address from, address to, uint value) public override returns (bool success) {\n', "        require(value <= allowance[from][msg.sender], 'Must not send more than allowance');\n", '        allowance[from][msg.sender] -= value;\n', '        _transfer(from, to, value);\n', '        return true;\n', '    }\n', '    \n', '  \n', '    \n', '    // Internal transfer function which includes the Fee\n', '    function _transfer(address _from, address _to, uint _value) private {\n', '        \n', '        messagesender = msg.sender; //this is the person actually making the call on this function\n', '        \n', '        \n', "        require(balanceOf[_from] >= _value, 'Must not send more than balance');\n", "        require(balanceOf[_to] + _value >= balanceOf[_to], 'Balance overflow');\n", '        \n', '        balanceOf[_from] -= _value;\n', '        if(Address_Whitelisted[msg.sender]){ //if the person making the transaction is whitelisted, the no burn on the transaction\n', '        \n', '          actualValue = _value;\n', '          \n', '        }else{\n', '         \n', '        bpValue = mulDiv(_value, 15, 10000); //this is 0.15% for basis point\n', '        actualValue = _value - bpValue; //this is the amount to be sent\n', '        \n', '        balanceOf[address(this)] += bpValue; //this is adding the basis point charged to this contract\n', '        emit Transfer(_from, address(this), bpValue);\n', '        \n', '        BPE += bpValue; //this is increasing the virtual basis point amount\n', '        emit BasisPointAdded(bpValue); \n', '        \n', '        \n', '        }\n', '        \n', '        if(emission_Whitelisted[messagesender] == false){ //this is so that staking and unstaking will not trigger the emission\n', '          \n', '                if(now >= nextDayTime){\n', '                \n', '                amountToEmit = emittingAmount();\n', '                \n', '                pool1Amount = mulDiv(amountToEmit, pool1percentage, 10000);\n', '                pool2Amount = mulDiv(amountToEmit, pool2percentage, 10000);\n', '                pool3Amount = mulDiv(amountToEmit, pool3percentage, 10000);\n', '                pool4Amount = mulDiv(amountToEmit, pool4percentage, 10000);\n', '                \n', '                \n', '                poolAmountTrig = mulDiv(amountToEmit, trigRewardpercentage, 10000);\n', '                TrigAmount = poolAmountTrig.div(2);\n', '                \n', '                pool1Amount = pool1Amount.sub(TrigAmount);\n', '                pool2Amount = pool2Amount.sub(TrigAmount);\n', '                \n', '                TrigReward = poolAmountTrig;\n', '                \n', '                uint Ofrozenamount = ospfrozen();\n', '                uint Dfrozenamount = dspfrozen();\n', '                uint Ufrozenamount = uspfrozen();\n', '                uint Afrozenamount = aspfrozen();\n', '                \n', '                if(Ofrozenamount > 0){\n', '                    \n', '                OSP(OraclePool).scaledToken(pool4Amount);\n', '                balanceOf[OraclePool] += pool4Amount;\n', '                emit Transfer(address(this), OraclePool, pool4Amount);\n', '                \n', '                \n', '                    \n', '                }else{\n', '                  \n', '                 balanceOf[address(this)] += pool4Amount; \n', '                 emit Transfer(address(this), address(this), pool4Amount);\n', '                 \n', '                 BPE += pool4Amount;\n', '                    \n', '                }\n', '                \n', '                if(Dfrozenamount > 0){\n', '                    \n', '                DSP(DefiPool).scaledToken(pool3Amount);\n', '                balanceOf[DefiPool] += pool3Amount;\n', '                emit Transfer(address(this), DefiPool, pool3Amount);\n', '                \n', '                \n', '                    \n', '                }else{\n', '                  \n', '                 balanceOf[address(this)] += pool3Amount; \n', '                 emit Transfer(address(this), address(this), pool3Amount);\n', '                 BPE += pool3Amount;\n', '                    \n', '                }\n', '                \n', '                if(Ufrozenamount > 0){\n', '                    \n', '                USP(swapPool).scaledToken(pool2Amount);\n', '                balanceOf[swapPool] += pool2Amount;\n', '                emit Transfer(address(this), swapPool, pool2Amount);\n', '                \n', '                    \n', '                }else{\n', '                  \n', '                 balanceOf[address(this)] += pool2Amount; \n', '                 emit Transfer(address(this), address(this), pool2Amount);\n', '                 BPE += pool2Amount;\n', '                    \n', '                }\n', '                \n', '                if(Afrozenamount > 0){\n', '                    \n', '                 ASP(lonePool).scaledToken(pool1Amount);\n', '                 balanceOf[lonePool] += pool1Amount;\n', '                 emit Transfer(address(this), lonePool, pool1Amount);\n', '                \n', '                }else{\n', '                  \n', '                 balanceOf[address(this)] += pool1Amount; \n', '                 emit Transfer(address(this), address(this), pool1Amount);\n', '                 BPE += pool1Amount;\n', '                    \n', '                }\n', '                \n', '                nextDayTime += secondsPerDay;\n', '                currentDay += 1; \n', '                emit NewDay(currentEpoch, currentDay, nextDayTime);\n', '                \n', '                //reward the wallet that triggered the EMISSION\n', '                balanceOf[_from] += TrigReward; //this is rewardig the person that triggered the emission\n', '                emit Transfer(address(this), _from, TrigReward);\n', '                emit TrigRewardEvent(address(this), msg.sender, TrigReward);\n', '                \n', '            }\n', '        \n', '            \n', '        }\n', '       \n', '       balanceOf[_to] += actualValue;\n', '       emit Transfer(_from, _to, actualValue);\n', '    }\n', '    \n', '    \n', '\n', '    \n', '   \n', '    //======================================EMISSION========================================//\n', '    // Internal - Update emission function\n', '    \n', '    function emittingAmount() internal returns(uint){\n', '       \n', '        if(now >= nextEpochTime){\n', '            \n', '            currentEpoch += 1;\n', '            \n', '            //if it is greater than the nextEpochTime, then it means we have entered the new epoch, \n', '            //thats why we are adding 1 to it, meaning new epoch emission\n', '            \n', '            if(currentEpoch > 10){\n', '            \n', '               emission = BPE;\n', '               BPE -= emission.div(2);\n', '               balanceOf[address(this)] -= emission.div(2);\n', '            \n', '               \n', '            }\n', '            emission = emission/2;\n', '            nextEpochTime += (secondsPerDay * daysPerEpoch);\n', '            emit NewEpoch(currentEpoch, emission, nextEpochTime);\n', '          \n', '        }\n', '        \n', '        return emission;\n', '        \n', '        \n', '    }\n', '  \n', '  \n', '  \n', '    function ospfrozen() public view returns(uint){\n', '        \n', '        return OSP(OraclePool).totalFrozen();\n', '       \n', '    }\n', '    \n', '    function dspfrozen() public view returns(uint){\n', '        \n', '        return DSP(DefiPool).totalFrozen();\n', '       \n', '    }\n', '    \n', '    function uspfrozen() public view returns(uint){\n', '        \n', '        return USP(swapPool).totalFrozen();\n', '       \n', '    } \n', '    \n', '    function aspfrozen() public view returns(uint){\n', '        \n', '        return ASP(lonePool).totalFrozen();\n', '       \n', '    }\n', '    \n', '     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {\n', '          (uint l, uint h) = fullMul (x, y);\n', '          assert (h < z);\n', '          uint mm = mulmod (x, y, z);\n', '          if (mm > l) h -= 1;\n', '          l -= mm;\n', '          uint pow2 = z & -z;\n', '          z /= pow2;\n', '          l /= pow2;\n', '          l += h * ((-pow2) / pow2 + 1);\n', '          uint r = 1;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          r *= 2 - z * r;\n', '          return l * r;\n', '    }\n', '    \n', '     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {\n', '          uint mm = mulmod (x, y, uint (-1));\n', '          l = x * y;\n', '          h = mm - l;\n', '          if (mm < l) h -= 1;\n', '    }\n', '    \n', '   \n', '}']