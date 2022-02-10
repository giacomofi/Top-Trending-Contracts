['pragma solidity ^0.4.24;\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '\n', '    function name() public view returns (string);\n', '    function symbol() public view returns (string);\n', '    function decimals() public view returns (uint8);\n', '\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '\n', '}\n', '\n', 'contract ERC223 {\n', '    function transferdata(address to, uint value, bytes data) payable public;\n', '    event Transferdata(address indexed from, address indexed to, uint value, bytes indexed data);\n', '}\n', '\n', '\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '\n', 'contract ERCAddressFrozenFund is ERC20{\n', '\n', '    using SafeMath for uint;\n', '\n', '    struct LockedWallet {\n', '        address owner; // the owner of the locked wallet, he/she must secure the private key\n', '        uint256 amount; //\n', '        uint256 start; // timestamp when "lock" function is executed\n', '        uint256 duration; // duration period in seconds. if we want to lock an amount for\n', '        uint256 release;  // release = start+duration\n', '        // "start" and "duration" is for bookkeeping purpose only. Only "release" will be actually checked once unlock function is called\n', '    }\n', '\n', '\n', '    address public owner;\n', '\n', '    uint256 _lockedSupply;\n', '\n', '    mapping (address => LockedWallet) addressFrozenFund; //address -> (deadline, amount),freeze fund of an address its so that no token can be transferred out until deadline\n', '\n', '    function mintToken(address _owner, uint256 amount) internal;\n', '    function burnToken(address _owner, uint256 amount) internal;\n', '\n', '    event LockBalance(address indexed addressOwner, uint256 releasetime, uint256 amount);\n', '    event LockSubBalance(address indexed addressOwner, uint256 index, uint256 releasetime, uint256 amount);\n', '    event UnlockBalance(address indexed addressOwner, uint256 releasetime, uint256 amount);\n', '    event UnlockSubBalance(address indexed addressOwner, uint256 index, uint256 releasetime, uint256 amount);\n', '\n', '    function lockedSupply() public view returns (uint256) {\n', '        return _lockedSupply;\n', '    }\n', '\n', '    function releaseTimeOf(address _owner) public view returns (uint256 releaseTime) {\n', '        return addressFrozenFund[_owner].release;\n', '    }\n', '\n', '    function lockedBalanceOf(address _owner) public view returns (uint256 lockedBalance) {\n', '        return addressFrozenFund[_owner].amount;\n', '    }\n', '\n', '    function lockBalance(uint256 duration, uint256 amount) public{\n', '\n', '        address _owner = msg.sender;\n', '\n', '        require(address(0) != _owner && amount > 0 && duration > 0 && balanceOf(_owner) >= amount);\n', '        require(addressFrozenFund[_owner].release <= now && addressFrozenFund[_owner].amount == 0);\n', '\n', '        addressFrozenFund[_owner].start = now;\n', '        addressFrozenFund[_owner].duration = duration;\n', '        addressFrozenFund[_owner].release = SafeMath.add(addressFrozenFund[_owner].start, duration);\n', '        addressFrozenFund[_owner].amount = amount;\n', '        burnToken(_owner, amount);\n', '        _lockedSupply = SafeMath.add(_lockedSupply, lockedBalanceOf(_owner));\n', '\n', '        emit LockBalance(_owner, addressFrozenFund[_owner].release, amount);\n', '    }\n', '\n', '    //_owner must call this function explicitly to release locked balance in a locked wallet\n', '    function releaseLockedBalance() public {\n', '\n', '        address _owner = msg.sender;\n', '\n', '        require(address(0) != _owner && lockedBalanceOf(_owner) > 0 && releaseTimeOf(_owner) <= now);\n', '        mintToken(_owner, lockedBalanceOf(_owner));\n', '        _lockedSupply = SafeMath.sub(_lockedSupply, lockedBalanceOf(_owner));\n', '\n', '        emit UnlockBalance(_owner, addressFrozenFund[_owner].release, lockedBalanceOf(_owner));\n', '\n', '        delete addressFrozenFund[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract CherryToken is ERC223, ERCAddressFrozenFund {\n', '\n', '    using SafeMath for uint;\n', '\n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '    address public fundsWallet;\n', '    uint256 internal fundsWalletChanged;\n', '\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '    constructor() public {\n', '        _symbol = "YT";\n', '        _name = "Cherry Token";\n', '        _decimals = 8;\n', '        _totalSupply = 10000000000000000;\n', '        balances[msg.sender] = _totalSupply;\n', '        fundsWallet = msg.sender;\n', '\n', '        owner = msg.sender;\n', '\n', '        fundsWalletChanged = 0;\n', '    }\n', '\n', '    function changeFundsWallet(address newOwner) public{\n', '        require(msg.sender == fundsWallet && fundsWalletChanged == 0);\n', '\n', '        balances[newOwner] = balances[fundsWallet];\n', '        balances[fundsWallet] = 0;\n', '        fundsWallet = newOwner;\n', '        fundsWalletChanged = 1;\n', '    }\n', '\n', '    function name() public view returns (string) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function mintToken(address _owner, uint256 amount) internal {\n', '        balances[_owner] = SafeMath.add(balances[_owner], amount);\n', '    }\n', '\n', '    function burnToken(address _owner, uint256 amount) internal {\n', '        balances[_owner] = SafeMath.sub(balances[_owner], amount);\n', '    }\n', '\n', '    function() payable public {\n', '\n', '        require(msg.sender == address(0));//disable ICO crowd sale 禁止ICO资金募集，因为本合约已经过了募集阶段\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        if(isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            bytes memory _data = new bytes(1);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        if(_from == fundsWallet){\n', '            require(_value <= balances[_from]);\n', '        }\n', '\n', '        if(isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            bytes memory _data = new bytes(1);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0)); \n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function transferdata(address _to, uint _value, bytes _data) public payable {\n', '        require(_value > 0 );\n', '        if(isContract(_to)) {\n', '            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '            receiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transferdata(msg.sender, _to, _value, _data);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly {\n', '        //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '        }\n', '        return (length>0);\n', '    }\n', '\n', '    function transferMultiple(address[] _tos, uint256[] _values, uint count)  payable public returns (bool) {\n', '        uint256 total = 0;\n', '        uint256 total_prev = 0;\n', '        uint i = 0;\n', '\n', '        for(i=0;i<count;i++){\n', '            require(_tos[i] != address(0) && !isContract(_tos[i]));//_tos must no contain any contract address\n', '\n', '            if(isContract(_tos[i])) {\n', '                ERC223ReceivingContract receiver = ERC223ReceivingContract(_tos[i]);\n', '                bytes memory _data = new bytes(1);\n', '                receiver.tokenFallback(msg.sender, _values[i], _data);\n', '            }\n', '\n', '            total_prev = total;\n', '            total = SafeMath.add(total, _values[i]);\n', '            require(total >= total_prev);\n', '        }\n', '\n', '        require(total <= balances[msg.sender]);\n', '\n', '        for(i=0;i<count;i++){\n', '            balances[msg.sender] = SafeMath.sub(balances[msg.sender], _values[i]);\n', '            balances[_tos[i]] = SafeMath.add(balances[_tos[i]], _values[i]);\n', '            emit Transfer(msg.sender, _tos[i], _values[i]);\n', '        }\n', '\n', '        return true;\n', '    }\n', '}']