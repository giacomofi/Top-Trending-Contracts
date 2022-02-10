['pragma solidity 0.4.24;\n', '\n', 'library SafeMath {\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    uint256 totalSupply_;\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal {\n', '        require(account != 0);\n', '        require(amount <= balances[account]);\n', '\n', '        totalSupply_ = totalSupply().sub(amount);\n', '        balances[account] = balances[account].sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _burnFrom(address account, uint256 amount) internal {\n', '        require(amount <= allowed[account][msg.sender]);\n', '\n', '        allowed[account][msg.sender] = allowed[account][msg.sender].sub(amount);\n', '        _burn(account, amount);\n', '    }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public isMinting = true;\n', '    uint256 public lockCountingFromTime = 0;\n', '\n', '    modifier canMint() {\n', '        require(isMinting);\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {\n', '        totalSupply_ = totalSupply_.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        emit Mint(_to, _amount);\n', '        emit Transfer(address(0), _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function finishMinting() public onlyOwner canMint returns (bool) {\n', '        isMinting = false;\n', '        lockCountingFromTime = now;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnableToken is StandardToken {\n', '\n', '  function burn(uint256 value) public {\n', '    _burn(msg.sender, value);\n', '  }\n', '\n', '  function burnFrom(address from, uint256 value) public {\n', '    _burnFrom(from, value);\n', '  }\n', '\n', '  function _burn(address who, uint256 value) internal {\n', '    super._burn(who, value);\n', '  }\n', '}\n', '\n', 'contract OSAToken is MintableToken, BurnableToken {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "OSAToken";\n', '    string public symbol = "OSA";\n', '    uint8 constant public decimals = 18;\n', '\n', '    uint256 constant public MAX_TOTAL_SUPPLY = 5777999888 * (10 ** uint256(decimals));\n', '\n', '    struct LockParams {\n', '        uint256 TIME;\n', '        uint256 AMOUNT;\n', '    }\n', '\n', '    mapping(address => LockParams[]) private holdAmounts;\n', '    address[] private holdAmountAccounts;\n', '\n', '    function isValidAddress(address _address) public view returns (bool) {\n', '        return (_address != 0x0 && _address != address(0) && _address != 0 && _address != address(this));\n', '    }\n', '\n', '    modifier validAddress(address _address) {\n', '        require(isValidAddress(_address));\n', '        _;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) public validAddress(_to) onlyOwner canMint returns (bool) {\n', '        if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY) {\n', '            return false;\n', '        }\n', '        return super.mint(_to, _amount);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {\n', '        require(checkAvailableAmount(msg.sender, _value));\n', '    \n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {\n', '        require(checkAvailableAmount(_from, _value));\n', '\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function setHoldAmount(address _address, uint256 _amount, uint256 _time) public onlyOwner {\n', '        require(getAvailableBalance(_address) >= _amount);\n', '        _setHold(_address, _amount, _time);\n', '    }\n', '\n', '    function _setHold(address _address, uint256 _amount, uint256 _time) internal {\n', '        LockParams memory lockdata;\n', '        if (lockCountingFromTime == 0) {\n', '            lockdata.TIME = _time;\n', '        } else {\n', '            lockdata.TIME = now.sub(lockCountingFromTime).add(_time);\n', '        }\n', '        lockdata.AMOUNT = _amount;\n', '\n', '        holdAmounts[_address].push(lockdata);\n', '        holdAmountAccounts.push(_address) - 1;\n', '    }\n', '\n', '    function getTotalHoldAmount(address _address) public view returns(uint256) {\n', '        uint256 totalHold = 0;\n', '        LockParams[] storage locks = holdAmounts[_address];\n', '        for (uint i = 0; i < locks.length; i++) {\n', '            if (lockCountingFromTime == 0 || lockCountingFromTime.add(locks[i].TIME) >= now) {\n', '                totalHold = totalHold.add(locks[i].AMOUNT);\n', '            }\n', '        }\n', '        return totalHold;\n', '    }\n', '\n', '    function getAvailableBalance(address _address) public view returns(uint256) {\n', '        return balanceOf(_address).sub(getTotalHoldAmount(_address));\n', '    }\n', '\n', '    function checkAvailableAmount(address _address, uint256 _amount) public view returns (bool) {\n', '        return _amount <= getAvailableBalance(_address);\n', '    }\n', '\n', '    function removeHoldByAddress(address _address) public onlyOwner {\n', '        delete holdAmounts[_address];\n', '    }\n', '\n', '    function removeHoldByAddressIndex(address _address, uint256 _index) public onlyOwner {\n', '        delete holdAmounts[_address][_index];\n', '    }\n', '\n', '    function changeHoldByAddressIndex(\n', '        address _address, uint256 _index, uint256 _amount, uint256 _time\n', '    ) public onlyOwner {\n', '        if (_amount > 0) {\n', '            holdAmounts[_address][_index].AMOUNT = _amount;\n', '        }\n', '        if (_time > 0) {\n', '            if (lockCountingFromTime == 0) {\n', '                holdAmounts[_address][_index].TIME = _time;\n', '            } else {\n', '                holdAmounts[_address][_index].TIME = now.sub(lockCountingFromTime).add(_time);\n', '            }\n', '        }\n', '    }\n', '\n', '    function getHoldAmountAccounts() public view onlyOwner returns (address[]) {\n', '        return holdAmountAccounts;\n', '    }\n', '\n', '    function countHoldAmount(address _address) public view onlyOwner returns (uint256) {\n', '        require(_address != 0x0 && _address != address(0));\n', '        return holdAmounts[_address].length;\n', '    }\n', '\n', '    function getHoldAmount(address _address, uint256 _idx) public view onlyOwner returns (uint256, uint256) {\n', '        require(_address != 0x0);\n', '        require(holdAmounts[_address].length>0);\n', '\n', '        return (holdAmounts[_address][_idx].TIME, holdAmounts[_address][_idx].AMOUNT);\n', '    }\n', '\n', '    function transferHoldFrom(\n', '        address _from, address _to, uint256 _value\n', '    ) public onlyOwner returns (bool) {\n', '        require(_to != address(0));\n', '        require(getTotalHoldAmount(_from) >= _value);\n', '        require(_value <= allowed[_from][tx.origin]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][tx.origin] = allowed[_from][tx.origin].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        uint256 lockedSourceAmount = 0;\n', '        uint lockedSourceAmountCount = 0;\n', '\n', '        LockParams[] storage locks = holdAmounts[_from];\n', '\n', '        for (uint i = 0; i < locks.length; i++) {\n', '            if (lockCountingFromTime == 0 || lockCountingFromTime.add(locks[i].TIME) >= now) {\n', '            \tlockedSourceAmount = lockedSourceAmount.add(locks[i].AMOUNT);\n', '                lockedSourceAmountCount++;\n', '            }\n', '        }\n', '\n', '        uint256 tosend = 0;\n', '        uint256 acc = 0;\n', '        uint j = 0;\n', '\n', '        for (i = 0; i < locks.length; i++) {\n', '            if (lockCountingFromTime == 0 || lockCountingFromTime.add(locks[i].TIME) >= now) {\n', '            \tif (j < lockedSourceAmountCount - 1) {\n', '    \t            tosend = locks[i].AMOUNT.mul(_value).div(lockedSourceAmount);\n', '    \t        } else {\n', '        \t        tosend = _value.sub(acc);\n', '    \t        }\n', '    \t        locks[i].AMOUNT = locks[i].AMOUNT.sub(tosend);\n', '    \t        acc = acc.add(tosend);\n', '    \t        _setHold(_to, tosend, locks[i].TIME);\n', '    \t        j++;\n', '            }\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function burnMintFrom(address _from, uint256 _amount) public onlyOwner canMint {\n', '        require(checkAvailableAmount(_from, _amount));\n', '        super._burn(_from, _amount);\n', '    }\n', '\n', '    function burnFrom(address from, uint256 value) public {\n', '        require(!isMinting);\n', '        require(checkAvailableAmount(from, value));\n', '        super.burnFrom(from, value);\n', '    }\n', '\n', '    function burn(uint256 value) public {\n', '        require(!isMinting);\n', '        require(checkAvailableAmount(msg.sender, value));\n', '        super.burn(value);\n', '    }\n', '\n', '}']