['pragma solidity ^0.4.15;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Base {\n', '    modifier only(address allowed) {\n', '        require(msg.sender == allowed);\n', '        _;\n', '    }\n', '    modifier onlyPayloadSize(uint size) {\n', '        assert(msg.data.length == size + 4);\n', '        _;\n', '    } \n', '    // *************************************************\n', '    // *          reentrancy handling                  *\n', '    // *************************************************\n', '    uint private bitlocks = 0;\n', '    modifier noReentrancy(uint m) {\n', '        var _locks = bitlocks;\n', '        require(_locks & m <= 0);\n', '        bitlocks |= m;\n', '        _;\n', '        bitlocks = _locks;\n', '    }\n', '    modifier noAnyReentrancy {\n', '        var _locks = bitlocks;\n', '        require(_locks <= 0);\n', '        bitlocks = uint(-1);\n', '        _;\n', '        bitlocks = _locks;\n', '    }\n', '    modifier reentrant { _; }\n', '}\n', '\n', '\n', 'contract ERC20 is Base {\n', '    using SafeMath for uint;\n', '    uint public totalSupply;\n', '    bool public isFrozen = false;\n', '    event Transfer(address indexed _from, address indexed _to, uint _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '    function transferFrom(address _from, address _to, uint _value) public isNotFrozenOnly onlyPayloadSize(3 * 32) returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve_fixed(address _spender, uint _currentValue, uint _value) public isNotFrozenOnly onlyPayloadSize(3 * 32) returns (bool success) {\n', '        if(allowed[msg.sender][_spender] == _currentValue){\n', '            allowed[msg.sender][_spender] = _value;\n', '            Approval(msg.sender, _spender, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public isNotFrozenOnly onlyPayloadSize(2 * 32) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '    modifier isNotFrozenOnly() {\n', '        require(!isFrozen);\n', '        _;\n', '    }\n', '\n', '    modifier isFrozenOnly(){\n', '        require(isFrozen);\n', '        _;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract Token is ERC20 {\n', '    string public name = "Array.io Token";\n', '    string public symbol = "eRAY";\n', '    uint8 public decimals = 18;\n', '    uint public constant BIT = 10**18;\n', '    uint public constant BASE = 10000 * BIT;\n', '    bool public tgeLive = false;\n', '    uint public tgeStartBlock;\n', '    uint public tgeSettingsAmount;\n', '    uint public tgeSettingsPartInvestor;\n', '    uint public tgeSettingsPartProject;\n', '    uint public tgeSettingsPartFounders;\n', '    uint public tgeSettingsBlocksPerStage;\n', '    uint public tgeSettingsPartInvestorIncreasePerStage;\n', '    uint public tgeSettingsAmountCollect;\n', '    uint public tgeSettingsMaxStages;\n', '    address public projectWallet;\n', '    address public foundersWallet;\n', '    address constant public burnAddress = address(0);\n', '    mapping (address => uint) public invBalances;\n', '    uint public totalInvSupply;\n', '\n', '    modifier isTgeLive(){\n', '        require(tgeLive);\n', '        _;\n', '    }\n', '\n', '    modifier isNotTgeLive(){\n', '        require(!tgeLive);\n', '        _;\n', '    }\n', '\n', '    modifier maxStagesIsNotAchieved() {\n', '        if (totalSupply > BIT) {\n', '            uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);\n', '            require(stage < tgeSettingsMaxStages);\n', '        }\n', '        _;\n', '    }\n', '\n', '    modifier targetIsNotAchieved(){\n', '        require(tgeSettingsAmountCollect < tgeSettingsAmount);\n', '        _;\n', '    }\n', '\n', '    event Burn(address indexed _owner,  uint _value);\n', '\n', '    function transfer(address _to, uint _value) public isNotFrozenOnly onlyPayloadSize(2 * 32) returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        if(balances[projectWallet] < 1 * BIT){\n', '            _internalTgeSetLive();\n', '        }\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Constructor\n', '    /// @param _projectWallet Wallet of project\n', '    /// @param _foundersWallet Wallet of founders\n', '    function Token(address _projectWallet, address _foundersWallet) public {\n', '        projectWallet = _projectWallet;\n', '        foundersWallet = _foundersWallet;\n', '    }\n', '\n', '    /// @dev Fallback function allows to buy tokens\n', '    function ()\n', '    public\n', '    payable\n', '    isTgeLive\n', '    isNotFrozenOnly\n', '    targetIsNotAchieved\n', '    maxStagesIsNotAchieved\n', '    noAnyReentrancy\n', '    {\n', '        require(msg.value > 0);\n', '        if(tgeSettingsAmountCollect.add(msg.value) >= tgeSettingsAmount){\n', '            _finishTge();\n', '        }\n', '        uint refundAmount = 0;\n', '        uint senderAmount = msg.value;\n', '        if(tgeSettingsAmountCollect.add(msg.value) >= tgeSettingsAmount){\n', '            refundAmount = tgeSettingsAmountCollect.add(msg.value).sub(tgeSettingsAmount);\n', '            senderAmount = (msg.value).sub(refundAmount);\n', '        }\n', '        uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);        \n', '        \n', '        uint currentPartInvestor = tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));\n', '        uint allStakes = currentPartInvestor.add(tgeSettingsPartProject).add(tgeSettingsPartFounders);\n', '        uint amountProject = senderAmount.mul(tgeSettingsPartProject).div(allStakes);\n', '        uint amountFounders = senderAmount.mul(tgeSettingsPartFounders).div(allStakes);\n', '        uint amountSender = senderAmount.sub(amountProject).sub(amountFounders);\n', '        _mint(amountProject, amountFounders, amountSender);\n', '        msg.sender.transfer(refundAmount);\n', '    }\n', '\n', '    function setFinished()\n', '    public\n', '    only(projectWallet)\n', '    isNotFrozenOnly\n', '    isTgeLive\n', '    {\n', '        if(balances[projectWallet] > 1*BIT){\n', '            _finishTge();\n', '        }\n', '    }\n', '\n', '    /// @dev Start new tge stage\n', '    function tgeSetLive()\n', '    public\n', '    only(projectWallet)\n', '    isNotTgeLive\n', '    isNotFrozenOnly\n', '    {\n', '        _internalTgeSetLive();\n', '    }\n', '\n', '    /// @dev Burn tokens to burnAddress from msg.sender wallet\n', '    /// @param _amount Amount of tokens\n', '    function burn(uint _amount)\n', '    public \n', '    isNotFrozenOnly\n', '    noAnyReentrancy    \n', '    returns(bool _success)\n', '    {\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[burnAddress] = balances[burnAddress].add(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '        msg.sender.transfer(_amount);\n', '        Transfer(msg.sender, burnAddress, _amount);\n', '        Burn(burnAddress, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @dev _foundersWallet Wallet of founders\n', '    /// @param dests array of addresses \n', '    /// @param values array amount of tokens to transfer    \n', '    function multiTransfer(address[] dests, uint[] values) \n', '    public \n', '    isNotFrozenOnly\n', '    returns(uint) \n', '    {\n', '        uint i = 0;\n', '        while (i < dests.length) {\n', '           transfer(dests[i], values[i]);\n', '           i += 1;\n', '        }\n', '        return i;\n', '    }\n', '\n', '    //---------------- FROZEN -----------------\n', '    /// @dev Allows an owner to confirm freezeng process\n', '    function setFreeze()\n', '    public\n', '    only(projectWallet)\n', '    isNotFrozenOnly\n', '    returns (bool)\n', '    {\n', '        isFrozen = true;\n', '        totalInvSupply = address(this).balance;\n', '        return true;\n', '    }\n', '\n', '    /// @dev Allows to users withdraw eth in frozen stage \n', '    function withdrawFrozen()\n', '    public\n', '    isFrozenOnly\n', '    noAnyReentrancy\n', '    {\n', '        require(invBalances[msg.sender] > 0);\n', '        \n', '        uint amountWithdraw = totalInvSupply.mul(invBalances[msg.sender]).div(totalSupply);        \n', '        invBalances[msg.sender] = 0;\n', '        msg.sender.transfer(amountWithdraw);\n', '    }\n', '\n', '    /// @dev Allows an owner to confirm a change settings request.\n', '    function executeSettingsChange(\n', '        uint amount, \n', '        uint partInvestor,\n', '        uint partProject, \n', '        uint partFounders, \n', '        uint blocksPerStage, \n', '        uint partInvestorIncreasePerStage,\n', '        uint maxStages\n', '    ) \n', '    public\n', '    only(projectWallet)\n', '    isNotTgeLive \n', '    isNotFrozenOnly\n', '    returns(bool success) \n', '    {\n', '        tgeSettingsAmount = amount;\n', '        tgeSettingsPartInvestor = partInvestor;\n', '        tgeSettingsPartProject = partProject;\n', '        tgeSettingsPartFounders = partFounders;\n', '        tgeSettingsBlocksPerStage = blocksPerStage;\n', '        tgeSettingsPartInvestorIncreasePerStage = partInvestorIncreasePerStage;\n', '        tgeSettingsMaxStages = maxStages;\n', '        return true;\n', '    }\n', '\n', '    //---------------- GETTERS ----------------\n', '    /// @dev Amount of blocks left to the end of this stage of TGE \n', '    function tgeStageBlockLeft() \n', '    public \n', '    view\n', '    isTgeLive\n', '    returns(uint)\n', '    {\n', '        uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);\n', '        return tgeStartBlock.add(stage.mul(tgeSettingsBlocksPerStage)).sub(block.number);\n', '    }\n', '\n', '    function tgeCurrentPartInvestor()\n', '    public\n', '    view\n', '    isTgeLive\n', '    returns(uint)\n', '    {\n', '        uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage);\n', '        return tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));\n', '    }\n', '\n', '    function tgeNextPartInvestor()\n', '    public\n', '    view\n', '    isTgeLive\n', '    returns(uint)\n', '    {\n', '        uint stage = block.number.sub(tgeStartBlock).div(tgeSettingsBlocksPerStage).add(1);        \n', '        return tgeSettingsPartInvestor.add(stage.mul(tgeSettingsPartInvestorIncreasePerStage));\n', '    }\n', '\n', '    //---------------- INTERNAL ---------------\n', '    function _finishTge()\n', '    internal\n', '    {\n', '        tgeLive = false;\n', '    }\n', '\n', '    function _mint(uint _amountProject, uint _amountFounders, uint _amountSender)\n', '    internal\n', '    {\n', '        balances[projectWallet] = balances[projectWallet].add(_amountProject);\n', '        balances[foundersWallet] = balances[foundersWallet].add(_amountFounders);\n', '        balances[msg.sender] = balances[msg.sender].add(_amountSender);\n', '        invBalances[msg.sender] = invBalances[msg.sender].add(_amountSender);\n', '        tgeSettingsAmountCollect = tgeSettingsAmountCollect.add(_amountProject+_amountFounders+_amountSender);\n', '        totalSupply = totalSupply.add(_amountProject+_amountFounders+_amountSender);\n', '        Transfer(0x0, msg.sender, _amountSender);\n', '        Transfer(0x0, projectWallet, _amountProject);\n', '        Transfer(0x0, foundersWallet, _amountFounders);\n', '    }\n', '\n', '    function _internalTgeSetLive()\n', '    internal\n', '    {\n', '        tgeLive = true;\n', '        tgeStartBlock = block.number;\n', '        tgeSettingsAmountCollect = 0;\n', '    }\n', '}']