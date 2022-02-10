['pragma solidity ^0.6.6;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event TransferOwnership(address _from, address _to);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "only owner");\n', '        _;\n', '    }\n', '\n', '    function setOwner(address _owner) external onlyOwner {\n', '        emit TransferOwnership(owner, _owner);\n', '        owner = _owner;\n', '    }\n', '}\n', '\n', 'contract ReSupply is Ownable {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    event Resupplier(uint256 indexed epoch, uint256 scaleFact);\n', '    event NewResupplier(address oldResupplier, address NewResupplier);\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint amount);\n', '    event Approval(address indexed owner, address indexed spender, uint amount);\n', '\n', '    string public name     = "ReSupply";\n', '    string public symbol   = "RSP";\n', '    uint8  public decimals = 18;\n', '    \n', '    address public resupplier;\n', '    \n', '    address public rewardAddress;\n', '\n', '    /**\n', '     * @notice Internal decimals used to handle scaling factor\n', '     */\n', '    uint256 public constant internalDecimals = 10**24;\n', '\n', '    /**\n', '     * @notice Used for percentage maths\n', '     */\n', '    uint256 public constant BASE = 10**18;\n', '\n', '    /**\n', '     * @notice Used for setting the anty fraud system\n', '     */\n', '    bool private isContractInitialized = false;\n', '    uint256 public constant START = 1604687400;\n', '    uint256 public  DAYS = 45;\n', '\n', '    /**\n', "     * @notice Scaling factor that adjusts everyone's balances if the price is above the peg\n", '     */\n', '    uint256 public rSPScaleFact  = BASE;\n', '\n', '    mapping (address => uint256) internal _rSPBalances;\n', '    mapping (address => mapping (address => uint256)) internal _allowedFragments;\n', '    \n', '    \n', '    mapping(address => bool) public whitelistFrom;\n', '    mapping(address => bool) public whitelistTo;\n', '    mapping(address => bool) public whitelistResupplier;\n', '    \n', '    \n', '    address public noResupplierAddress;\n', '    address public sellerAddress;\n', '    \n', '    uint256 initSupply = 0;\n', '    uint256 _totalSupply = 0;\n', '    uint16 public SELL_FEE = 33;\n', '    uint16 public TX_FEE = 50;\n', '    \n', '    event WhitelistFrom(address _addr, bool _whitelisted);\n', '    event WhitelistTo(address _addr, bool _whitelisted);\n', '    event WhitelistResupplier(address _addr, bool _whitelisted);\n', '    \n', '     constructor(\n', '        uint256 initialSupply,\n', '        address initialSupplyAddr\n', '        \n', '        ) public {\n', '        owner = msg.sender;\n', '        emit TransferOwnership(address(0), msg.sender);\n', '        _mint(initialSupplyAddr,initialSupply);\n', '        isContractInitialized = true;\n', '        \n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function getSellBurn(uint256 value) public view returns (uint256)  {\n', '        uint256 nPercent = value.divRound(SELL_FEE);\n', '        return nPercent;\n', '    }\n', '    function getTxBurn(uint256 value) public view returns (uint256)  {\n', '        uint256 nPercent = value.divRound(TX_FEE);\n', '        return nPercent;\n', '    }\n', '    \n', '    function _isWhitelisted(address _from, address _to) internal view returns (bool) {\n', '        return whitelistFrom[_from]||whitelistTo[_to];\n', '    }\n', '    function _isResupplierWhitelisted(address _addr) internal view returns (bool) {\n', '        return whitelistResupplier[_addr];\n', '    }\n', '\n', '    function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {\n', '        emit WhitelistTo(_addr, _whitelisted);\n', '        whitelistTo[_addr] = _whitelisted;\n', '    }\n', '    \n', '    function setTxFee(uint16 fee) external onlyResupplier {\n', '        TX_FEE = fee;\n', '    }\n', '    \n', '    function setSellFee(uint16 fee) external onlyResupplier {\n', '        SELL_FEE = fee;\n', '    }\n', '    \n', '    function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {\n', '        emit WhitelistFrom(_addr, _whitelisted);\n', '        whitelistFrom[_addr] = _whitelisted;\n', '    }\n', '      \n', '    function setWhitelistedResupplier(address _addr, bool _whitelisted) external onlyOwner {\n', '        emit WhitelistResupplier(_addr, _whitelisted);\n', '        whitelistResupplier[_addr] = _whitelisted;\n', '    }\n', '    \n', '    function setNoResupplierAddress(address _addr) external onlyOwner {\n', '        noResupplierAddress = _addr;\n', '    }\n', '    \n', '    // Configures the seller address\n', '    function setSellerAddress(address _addr) external onlyOwner {\n', '        sellerAddress = _addr;\n', '    }\n', '   \n', '   \n', '\n', '\n', '    modifier onlyResupplier() {\n', '        require(msg.sender == resupplier);\n', '        _;\n', '    }\n', '\n', '\n', '\n', '    \n', '    /**\n', '    * @notice Computes the current max scaling factor\n', '    */\n', '    function maxScaleFact()\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _maxScaleFact();\n', '    }\n', '\n', '    function _maxScaleFact()\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // scaling factor can only go up to 2**256-1 = initSupply * rSPScaleFact\n', '        // this is used to check if rSPScaleFact will be too high to compute balances when rebasing.\n', '        return uint256(-1) / initSupply;\n', '    }\n', '\n', '   \n', '    function _mint(address to, uint256 amount)\n', '        internal\n', '    {\n', '      // increase totalSupply\n', '      _totalSupply = _totalSupply.add(amount);\n', '\n', '      // get underlying value\n', '      uint256 rSPValue = amount.mul(internalDecimals).div(rSPScaleFact);\n', '\n', '      // increase initSupply\n', '      initSupply = initSupply.add(rSPValue);\n', '\n', '      // make sure the mint didnt push maxScaleFact too low\n', '      require(rSPScaleFact <= _maxScaleFact(), "max scaling factor too low");\n', '\n', '      // add balance\n', '      _rSPBalances[to] = _rSPBalances[to].add(rSPValue);\n', '      \n', '      emit Transfer(address(0),to,amount);\n', '\n', '     \n', '    }\n', '\n', '   function isActive() public view returns (bool) {\n', '        return (\n', '            isContractInitialized == true &&\n', '            now >= START && // Must be after the START date\n', '            now <= START.add(DAYS * 1 days)&& // Must be before the end date\n', '            endOfPSWP() == false\n', '            );\n', '    }\n', '\n', '    function endOfPSWP() public view returns (bool) {\n', '        return (now >= START.add(DAYS * 1 days));\n', '    }\n', '\n', '    function endEarly(uint256 _DAYS) external onlyOwner {\n', '        DAYS = DAYS - _DAYS;\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens to a specified address.\n', '    * @param to The address to transfer to.\n', '    * @param value The amount to be transferred.\n', '    * @return True on success, false otherwise.\n', '    */\n', '    function transfer(address to, uint256 value)\n', '        external\n', '        returns (bool)\n', '    {\n', '       \n', '        // underlying balance is stored in rSP, so divide by current scaling factor\n', '\n', '        // note, this means as scaling factor grows, dust will be untransferrable.\n', '        // minimum transfer value == rSPScaleFact / 1e24;\n', '        \n', '        // get amount in underlying\n', '        //from noresupplierWallet\n', '\n', '      if (isActive() == false || msg.sender == owner || msg.sender == sellerAddress){\n', '\n', '        if(_isResupplierWhitelisted(msg.sender)){\n', '            uint256 noReValue = value.mul(internalDecimals).div(BASE);\n', '            uint256 noReNextValue = noReValue.mul(BASE).div(rSPScaleFact);\n', '            _rSPBalances[msg.sender] = _rSPBalances[msg.sender].sub(noReValue); //value==underlying\n', '            _rSPBalances[to] = _rSPBalances[to].add(noReNextValue);\n', '            emit Transfer(msg.sender, to, value);\n', '        }\n', '        else if(_isResupplierWhitelisted(to)){\n', '            uint256 fee = getSellBurn(value);\n', '            uint256 tokensToBurn = fee/2;\n', '            uint256 tokensForRewards = fee-tokensToBurn;\n', '            uint256 tokensToTransfer = value-fee;\n', '                \n', '            uint256 rSPValue = value.mul(internalDecimals).div(rSPScaleFact);\n', '            uint256 rSPValueKeep = tokensToTransfer.mul(internalDecimals).div(rSPScaleFact);\n', '            uint256 rSPValueReward = tokensForRewards.mul(internalDecimals).div(rSPScaleFact);\n', '            \n', '            \n', '            uint256 rSPNextValue = rSPValueKeep.mul(rSPScaleFact).div(BASE);\n', '            \n', '            _totalSupply = _totalSupply-fee;\n', '            _rSPBalances[address(0)] = _rSPBalances[address(0)].add(fee/2);\n', '            _rSPBalances[msg.sender] = _rSPBalances[msg.sender].sub(rSPValue); \n', '            _rSPBalances[to] = _rSPBalances[to].add(rSPNextValue);\n', '            _rSPBalances[rewardAddress] = _rSPBalances[rewardAddress].add(rSPValueReward);\n', '            emit Transfer(msg.sender, to, tokensToTransfer);\n', '            emit Transfer(msg.sender, address(0), tokensToBurn);\n', '            emit Transfer(msg.sender, rewardAddress, tokensForRewards);\n', '        }\n', '        else{\n', '          if(!_isWhitelisted(msg.sender, to)){\n', '                uint256 fee = getTxBurn(value);\n', '                uint256 tokensToBurn = fee/2;\n', '                uint256 tokensForRewards = fee-tokensToBurn;\n', '                uint256 tokensToTransfer = value-fee;\n', '                    \n', '                uint256 rSPValue = value.mul(internalDecimals).div(rSPScaleFact);\n', '                uint256 rSPValueKeep = tokensToTransfer.mul(internalDecimals).div(rSPScaleFact);\n', '                uint256 rSPValueReward = tokensForRewards.mul(internalDecimals).div(rSPScaleFact);\n', '                \n', '                _totalSupply = _totalSupply-fee;\n', '                _rSPBalances[address(0)] = _rSPBalances[address(0)].add(fee/2);\n', '                _rSPBalances[msg.sender] = _rSPBalances[msg.sender].sub(rSPValue); \n', '                _rSPBalances[to] = _rSPBalances[to].add(rSPValueKeep);\n', '                _rSPBalances[rewardAddress] = _rSPBalances[rewardAddress].add(rSPValueReward);\n', '                \n', '                \n', '                emit Transfer(msg.sender, to, tokensToTransfer);\n', '                emit Transfer(msg.sender, address(0), tokensToBurn);\n', '                emit Transfer(msg.sender, rewardAddress, tokensForRewards);\n', '           }\n', '             else{\n', '                uint256 rSPValue = value.mul(internalDecimals).div(rSPScaleFact);\n', '               \n', '                _rSPBalances[msg.sender] = _rSPBalances[msg.sender].sub(rSPValue); \n', '                _rSPBalances[to] = _rSPBalances[to].add(rSPValue);\n', '                emit Transfer(msg.sender, to, rSPValue);\n', '             }\n', '        }\n', '        return true;\n', '      }\n', '    else {return false;} }\n', '\n', '\n', '\n', '    /**\n', '    * @dev Transfer tokens from one address to another.\n', '    * @param from The address you want to send tokens from.\n', '    * @param to The address you want to transfer to.\n', '    * @param value The amount of tokens to be transferred.\n', '    */\n', '    function transferFrom(address from, address to, uint256 value)\n', '        external\n', '        returns (bool)\n', '    {\n', '        // decrease allowance\n', '        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);\n', '        \n', '        if (isActive() == false || msg.sender == owner || msg.sender == sellerAddress){\n', '\n', '        if(_isResupplierWhitelisted(from)){\n', '            uint256 noReValue = value.mul(internalDecimals).div(BASE);\n', '            uint256 noReNextValue = noReValue.mul(BASE).div(rSPScaleFact);\n', '            _rSPBalances[from] = _rSPBalances[from].sub(noReValue); //value==underlying\n', '            _rSPBalances[to] = _rSPBalances[to].add(noReNextValue);\n', '            emit Transfer(from, to, value);\n', '        }\n', '        else if(_isResupplierWhitelisted(to)){\n', '            uint256 fee = getSellBurn(value);\n', '            uint256 tokensForRewards = fee-(fee/2);\n', '            uint256 tokensToTransfer = value-fee;\n', '            \n', '            uint256 rSPValue = value.mul(internalDecimals).div(rSPScaleFact);\n', '            uint256 rSPValueKeep = tokensToTransfer.mul(internalDecimals).div(rSPScaleFact);\n', '            uint256 rSPValueReward = tokensForRewards.mul(internalDecimals).div(rSPScaleFact);\n', '            uint256 rSPNextValue = rSPValueKeep.mul(rSPScaleFact).div(BASE);\n', '            \n', '            _totalSupply = _totalSupply-fee;\n', '            \n', '            _rSPBalances[from] = _rSPBalances[from].sub(rSPValue); \n', '            _rSPBalances[to] = _rSPBalances[to].add(rSPNextValue);\n', '            _rSPBalances[rewardAddress] = _rSPBalances[rewardAddress].add(rSPValueReward);\n', '            _rSPBalances[address(0)] = _rSPBalances[address(0)].add(fee/2);\n', '            emit Transfer(from, to, tokensToTransfer);\n', '            emit Transfer(from, address(0), fee/2);\n', '            emit Transfer(from, rewardAddress, tokensForRewards);\n', '        }\n', '        else{\n', '          if(!_isWhitelisted(from, to)){\n', '                uint256 fee = getTxBurn(value);\n', '                uint256 tokensToBurn = fee/2;\n', '                uint256 tokensForRewards = fee-tokensToBurn;\n', '                uint256 tokensToTransfer = value-fee;\n', '                    \n', '                uint256 rSPValue = value.mul(internalDecimals).div(rSPScaleFact);\n', '                uint256 rSPValueKeep = tokensToTransfer.mul(internalDecimals).div(rSPScaleFact);\n', '                uint256 rSPValueReward = tokensForRewards.mul(internalDecimals).div(rSPScaleFact);\n', '            \n', '                _totalSupply = _totalSupply-fee;\n', '                _rSPBalances[address(0)] = _rSPBalances[address(0)].add(fee/2);\n', '                _rSPBalances[from] = _rSPBalances[from].sub(rSPValue); \n', '                _rSPBalances[to] = _rSPBalances[to].add(rSPValueKeep);\n', '                _rSPBalances[rewardAddress] = _rSPBalances[rewardAddress].add(rSPValueReward);\n', '                emit Transfer(from, to, tokensToTransfer);\n', '                emit Transfer(from, address(0), tokensToBurn);\n', '                emit Transfer(from, rewardAddress, tokensForRewards);\n', '           }\n', '             else{\n', '                uint256 rSPValue = value.mul(internalDecimals).div(rSPScaleFact);\n', '               \n', '                _rSPBalances[from] = _rSPBalances[from].sub(rSPValue); \n', '                _rSPBalances[to] = _rSPBalances[to].add(rSPValue);\n', '                emit Transfer(from, to, rSPValue);\n', '                \n', '            \n', '             }\n', '        }\n', '        return true;\n', '      }\n', '    }\n', '    \n', '\n', '    /**\n', '    * @param who The address to query.\n', '    * @return The balance of the specified address.\n', '    */\n', '    function balanceOf(address who)\n', '      external\n', '      view\n', '      returns (uint256)\n', '    {\n', '      if(_isResupplierWhitelisted(who)){\n', '        return _rSPBalances[who].mul(BASE).div(internalDecimals);\n', '      }\n', '      else{\n', '        return _rSPBalances[who].mul(rSPScaleFact).div(internalDecimals);\n', '      }\n', '    }\n', '\n', '    /** @notice Currently returns the internal storage amount\n', '    * @param who The address to query.\n', '    * @return The underlying balance of the specified address.\n', '    */\n', '    function balanceOfUnderlying(address who)\n', '      external\n', '      view\n', '      returns (uint256)\n', '    {\n', '      return _rSPBalances[who];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner has allowed to a spender.\n', '     * @param owner_ The address which owns the funds.\n', '     * @param spender The address which will spend the funds.\n', '     * @return The number of tokens still available for the spender.\n', '     */\n', '    function allowance(address owner_, address spender)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowedFragments[owner_][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of\n', '     * msg.sender. This method is included for ERC20 compatibility.\n', '     * increaseAllowance and decreaseAllowance should be used instead.\n', '     * Changing an allowance with this method brings the risk that someone may transfer both\n', '     * the old and the new allowance - if they are both greater than zero - if a transfer\n', '     * transaction is mined before the later approve() call is mined.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param value The amount of tokens to be spent.\n', '     */\n', '    function approve(address spender, uint256 value)\n', '        external\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] = value;\n', '        emit Approval(msg.sender, spender, value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner has allowed to a spender.\n', '     * This method should be used instead of approve() to avoid the double approval vulnerability\n', '     * described above.\n', '     * @param spender The address which will spend the funds.\n', '     * @param addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseAllowance(address spender, uint256 addedValue)\n', '        external\n', '        returns (bool)\n', '    {\n', '        _allowedFragments[msg.sender][spender] =\n', '            _allowedFragments[msg.sender][spender].add(addedValue);\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner has allowed to a spender.\n', '     *\n', '     * @param spender The address which will spend the funds.\n', '     * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseAllowance(address spender, uint256 subtractedValue)\n', '        external\n', '        returns (bool)\n', '    {\n', '        uint256 oldValue = _allowedFragments[msg.sender][spender];\n', '        if (subtractedValue >= oldValue) {\n', '            _allowedFragments[msg.sender][spender] = 0;\n', '        } else {\n', '            _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);\n', '        return true;\n', '    }\n', '\n', '    /* - Governance Functions - */\n', '\n', '    /** @notice sets the resupplier\n', '     * @param resupplier_ The address of the resupplier contract to use for authentication.\n', '     */\n', '    function _setResupplier(address resupplier_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        address oldResupplier = resupplier;\n', '        resupplier = resupplier_;\n', '        emit NewResupplier(oldResupplier, resupplier_);\n', '    }\n', '    \n', '     function _setRewardAddress(address rewards_)\n', '        external\n', '        onlyOwner\n', '    {\n', '        rewardAddress = rewards_;\n', '      \n', '    }\n', '    \n', '    /**\n', '    * @notice Initiates a new resupplier operation, provided the minimum time period has elapsed.\n', '    *\n', '    * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / resupplierLag\n', '    *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate\n', '    *      and targetRate is CpiOracleRate / baseCpi\n', '    */\n', '    function resupply(\n', '        uint256 epoch,\n', '        uint256 indexDelta,\n', '        bool positive\n', '    )\n', '        external\n', '        onlyResupplier\n', '        returns (uint256)\n', '    {\n', '        if (indexDelta == 0 || !positive) {\n', '          emit Resupplier(epoch, rSPScaleFact);\n', '          return _totalSupply;\n', '        }\n', '\n', '            uint256 newScaleFact = rSPScaleFact.mul(BASE.add(indexDelta)).div(BASE);\n', '            if (newScaleFact < _maxScaleFact()) {\n', '                rSPScaleFact = newScaleFact;\n', '            } else {\n', '              rSPScaleFact = _maxScaleFact();\n', '            }\n', '        \n', '\n', '        _totalSupply = ((initSupply.sub(_rSPBalances[address(0)]).sub(_rSPBalances[noResupplierAddress]))\n', '                        .mul(rSPScaleFact).div(internalDecimals))\n', '                        .add(_rSPBalances[noResupplierAddress].mul(BASE).div(internalDecimals));\n', '        emit Resupplier(epoch, rSPScaleFact);\n', '        return _totalSupply;\n', '    }\n', '}\n', '\n', '    \n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', ' \n', ' function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', ' \n', ' function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '  \n', '  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {\n', '    uint256 c = add(a,m);\n', '    uint256 d = sub(c,1);\n', '    return mul(div(d,m),m);\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '  \n', '  function divRound(uint256 x, uint256 y) internal pure returns (uint256) {\n', '        require(y != 0, "Div by zero");\n', '        uint256 r = x / y;\n', '        if (x % y != 0) {\n', '            r = r + 1;\n', '        }\n', '\n', '        return r;\n', '    }\n', '}']