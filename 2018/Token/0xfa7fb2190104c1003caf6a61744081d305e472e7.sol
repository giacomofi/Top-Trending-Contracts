['pragma solidity ^0.4.24;\n', '\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender)\n', '        public view returns (uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value)\n', '        public returns (bool);\n', '\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '    )\n', '    public\n', '    view\n', '    returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint256 _addedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = (\n', '        allowed[msg.sender][_spender].add(_addedValue));\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint256 _subtractedValue\n', '    )\n', '    public\n', '    returns (bool)\n', '    {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract TMTGOwnable {\n', '    address public owner;\n', '    address public centralBanker;\n', '    address public superOwner;\n', '    address public hiddenOwner;\n', '    \n', '    enum Role { owner, centralBanker, superOwner, hiddenOwner }\n', '\n', '    mapping(address => bool) public operators;\n', '    \n', '    \n', '    event TMTG_RoleTransferred(\n', '        Role indexed ownerType,\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '    \n', '    event TMTG_SetOperator(address indexed operator); \n', '    event TMTG_DeletedOperator(address indexed operator);\n', '    \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyOwnerOrOperator() {\n', '        require(msg.sender == owner || operators[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyNotBankOwner(){\n', '        require(msg.sender != centralBanker);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyBankOwner(){\n', '        require(msg.sender == centralBanker);\n', '        _;\n', '    }\n', '    \n', '    modifier onlySuperOwner() {\n', '        require(msg.sender == superOwner);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyhiddenOwner(){\n', '        require(msg.sender == hiddenOwner);\n', '        _;\n', '    }\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;     \n', '        centralBanker = msg.sender;\n', '        superOwner = msg.sender; \n', '        hiddenOwner = msg.sender;\n', '    }\n', '\n', '    function setOperator(address _operator) external onlySuperOwner {\n', '        operators[_operator] = true;\n', '        emit TMTG_SetOperator(_operator);\n', '    }\n', '\n', '    function delOperator(address _operator) external onlySuperOwner {\n', '        operators[_operator] = false;\n', '        emit TMTG_DeletedOperator(_operator);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlySuperOwner {\n', '        emit TMTG_RoleTransferred(Role.owner, owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function transferBankOwnership(address newBanker) public onlySuperOwner {\n', '        emit TMTG_RoleTransferred(Role.centralBanker, centralBanker, newBanker);\n', '        centralBanker = newBanker;\n', '    }\n', ' \n', '    function transferSuperOwnership(address newSuperOwner) public onlyhiddenOwner {\n', '        emit TMTG_RoleTransferred(Role.superOwner, superOwner, newSuperOwner);\n', '        superOwner = newSuperOwner;\n', '    }\n', '  \n', '    function changehiddenOwner(address newhiddenOwner) public onlyhiddenOwner {\n', '        emit TMTG_RoleTransferred(Role.hiddenOwner, hiddenOwner, newhiddenOwner);\n', '        hiddenOwner = newhiddenOwner;\n', '    }\n', '}\n', '\n', 'contract TMTGPausable is TMTGOwnable {\n', '    event TMTG_Pause();\n', '    event TMTG_Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '  \n', '    function pause() onlyOwnerOrOperator whenNotPaused public {\n', '        paused = true;\n', '        emit TMTG_Pause();\n', '    }\n', '  \n', '    function unpause() onlyOwnerOrOperator whenPaused public {\n', '        paused = false;\n', '        emit TMTG_Unpause();\n', '    }\n', '}\n', '\n', 'contract TMTGBlacklist is TMTGOwnable {\n', '    mapping(address => bool) blacklisted;\n', '    \n', '    event TMTG_Blacklisted(address indexed blacklist);\n', '    event TMTG_Whitelisted(address indexed whitelist);\n', '\n', '    modifier whenPermitted(address node) {\n', '        require(!blacklisted[node]);\n', '        _;\n', '    }\n', '\n', '    function isPermitted(address node) public view returns (bool) {\n', '        return !blacklisted[node];\n', '    }\n', '\n', '    function blacklist(address node) public onlyOwnerOrOperator {\n', '        blacklisted[node] = true;\n', '        emit TMTG_Blacklisted(node);\n', '    }\n', '\n', '    function unblacklist(address node) public onlyOwnerOrOperator {\n', '        blacklisted[node] = false;\n', '        emit TMTG_Whitelisted(node);\n', '    }\n', '}\n', '\n', 'contract HasNoEther is TMTGOwnable {\n', '    constructor() public payable {\n', '        require(msg.value == 0);\n', '    }\n', '\n', '    function() external {\n', '    }\n', '\n', '    function reclaimEther() external onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '}\n', '\n', 'contract TMTGBaseToken is StandardToken, TMTGPausable, TMTGBlacklist, HasNoEther {\n', '    \n', '    event TMTG_TransferFrom(address indexed owner, address indexed spender, address indexed to, uint256 value);\n', '    event TMTG_Burn(address indexed burner, uint256 value);\n', '    \n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool ret) {\n', '        ret = super.approve(_spender, _value);\n', '    }\n', '    \n', '    function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool ret) {\n', '        ret = super.increaseApproval(_spender, _addedValue);\n', '    }\n', '    \n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool ret) {\n', '        ret = super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);\n', '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '\n', '        emit Transfer(_who, address(0), _value);\n', '        emit TMTG_Burn(_who, _value);\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool) {\n', '        _burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool) {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        \n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function reclaimToken() external onlyOwner {\n', '        transfer(owner, balanceOf(this));\n', '    }\n', '    \n', '    \n', '    function destroy() onlyhiddenOwner public {\n', '        selfdestruct(superOwner);\n', '    }    \n', '}\n', '\n', 'contract TMTG is TMTGBaseToken {\n', '    string public constant name = "The Midas Touch Gold";\n', '    string public constant symbol = "TMTG";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals));\n', '    uint256 public openingTime;\n', '    \n', '    struct investor {\n', '        uint256 _sentAmount;\n', '        uint256 _initialAmount;\n', '        uint256 _limit;\n', '    }\n', '\n', '    mapping(address => investor) public searchInvestor;\n', '    mapping(address => bool) public superInvestor;\n', '    mapping(address => bool) public CEx;\n', '    mapping(address => bool) public investorList;\n', '\n', '    event TMTG_SetInvestor(address indexed investor); \n', '    event TMTG_DeleteInvestor(address indexed investor);\n', '    event TMTG_Stash(uint256 _value);\n', '    event TMTG_Unstash(uint256 _value);\n', '    event TMTG_SetCEx(address indexed CEx); \n', '    event TMTG_DeleteCEx(address indexed CEx);\n', '    event TMTG_SetSuperInvestor(address indexed SuperInvestor); \n', '    event TMTG_DeleteSuperInvestor(address indexed SuperInvestor);\n', '    \n', '    constructor() public {\n', '        totalSupply_ = INITIAL_SUPPLY;\n', '        balances[msg.sender] = INITIAL_SUPPLY;\n', '        openingTime = block.timestamp;\n', '\n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '    }\n', '\n', '    function setCEx(address _CEx) external onlySuperOwner {   \n', '        CEx[_CEx] = true;\n', '        \n', '        emit TMTG_SetCEx(_CEx);\n', '    }\n', '\n', '    function delCEx(address _CEx) external onlySuperOwner {   \n', '        CEx[_CEx] = false;\n', '        \n', '        emit TMTG_DeleteCEx(_CEx);\n', '    }\n', '\n', '    function setSuperInvestor(address _super) external onlySuperOwner {\n', '        superInvestor[_super] = true;\n', '        \n', '        emit TMTG_SetSuperInvestor(_super);\n', '    }\n', '    \n', '    function delSuperInvestor(address _super) external onlySuperOwner {\n', '        superInvestor[_super] = false;\n', '        \n', '        emit TMTG_DeleteSuperInvestor(_super);\n', '    }\n', '    \n', '    function setOpeningTime() onlyOwner public {\n', '        openingTime = block.timestamp;\n', '    }\n', '\n', '    function delInvestor(address _addr) onlySuperOwner public {\n', '        investorList[_addr] = false;\n', '        searchInvestor[_addr] = investor(0,0,0);\n', '        emit TMTG_DeleteInvestor(_addr);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused onlyNotBankOwner returns (bool) {\n', '        require(!superInvestor[msg.sender]);\n', '        return super.approve(_spender,_value);     \n', '    }\n', '\n', '    function _timelimitCal(address who) internal view returns (uint256) {\n', '        uint256 presentTime = block.timestamp;\n', '        uint256 timeValue = presentTime.sub(openingTime);\n', '        uint256 _result = timeValue.div(30 days);\n', '\n', '        return _result.mul(searchInvestor[who]._limit);\n', '    }\n', '\n', '    function _transferInvestor(address _to, uint256 _value) internal returns (bool ret) {\n', '        uint256 addedValue = searchInvestor[msg.sender]._sentAmount.add(_value);\n', '        \n', '        require(_timelimitCal(msg.sender) >= addedValue);\n', '        \n', '        searchInvestor[msg.sender]._sentAmount = searchInvestor[msg.sender]._sentAmount.sub(_value);\n', '        ret = super.transfer(_to, _value);\n', '        if (!ret) {\n', '            searchInvestor[msg.sender]._sentAmount = searchInvestor[msg.sender]._sentAmount.add(_value);\n', '        }\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public\n', '    whenPermitted(msg.sender) whenPermitted(_to) whenNotPaused onlyNotBankOwner\n', '    returns (bool) {   \n', '        \n', '        if(investorList[msg.sender]) {\n', '            return _transferInvestor(_to, _value);\n', '        \n', '        } else {\n', '            if (superInvestor[msg.sender]) {\n', '                require(_to != owner);\n', '                require(!superInvestor[_to]);\n', '                require(!CEx[_to]);\n', '\n', '                if(!investorList[_to]){\n', '                    investorList[_to] = true;\n', '                    searchInvestor[_to] = investor(0, _value, _value.div(10));\n', '                    emit TMTG_SetInvestor(_to); \n', '                }\n', '            }\n', '            return super.transfer(_to, _value);\n', '        }\n', '    }\n', '\n', '    function _transferFromInvestor(address _from, address _to, uint256 _value)\n', '    public returns(bool ret) {\n', '        uint256 addedValue = searchInvestor[_from]._sentAmount.add(_value);\n', '        require(_timelimitCal(_from) >= addedValue);\n', '        searchInvestor[_from]._sentAmount = searchInvestor[_from]._sentAmount.sub(_value);\n', '        ret = super.transferFrom(_from, _to, _value);\n', '\n', '        if (!ret) {\n', '            searchInvestor[_from]._sentAmount = searchInvestor[_from]._sentAmount.add(_value);\n', '        }else {\n', '            emit TMTG_TransferFrom(_from, msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '    public whenNotPaused whenPermitted(msg.sender) whenPermitted(_to) returns (bool ret)\n', '    {   \n', '        if(investorList[_from]) {\n', '            return _transferFromInvestor(_from,_to, _value);\n', '        } else {\n', '            ret = super.transferFrom(_from, _to, _value);\n', '            emit TMTG_TransferFrom(_from, msg.sender, _to, _value);\n', '        }\n', '    }\n', '\n', '    function getLimitPeriod() public view returns (uint256) {\n', '        uint256 presentTime = block.timestamp;\n', '        uint256 timeValue = presentTime.sub(openingTime);\n', '        uint256 result = timeValue.div(30 days);\n', '        return result;\n', '    }\n', '    \n', '    function stash(uint256 _value) public onlyOwner {\n', '        require(balances[owner] >= _value);\n', '        \n', '        balances[owner] = balances[owner].sub(_value);\n', '        \n', '        balances[centralBanker] = balances[centralBanker].add(_value);\n', '        \n', '        emit TMTG_Stash(_value);        \n', '    }\n', '\n', '    function unstash(uint256 _value) public onlyBankOwner {\n', '        require(balances[centralBanker] >= _value);\n', '        \n', '        balances[centralBanker] = balances[centralBanker].sub(_value);\n', '        \n', '        balances[owner] = balances[owner].add(_value);\n', '        \n', '        emit TMTG_Unstash(_value);\n', '    }\n', '}']