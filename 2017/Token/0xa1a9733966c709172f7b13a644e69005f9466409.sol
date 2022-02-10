['pragma solidity 0.4.16;\n', '\n', 'contract ERC20Interface {\n', '    function totalSupply() constant returns (uint256 total);\n', '\n', '    function balanceOf(address _who) constant returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract CryptoTestToken is ERC20Interface {\n', '    using SafeMath for uint256;\n', '\n', '    string public name = "CrypotaPay Token";\n', '    string public symbol = "CTT";\n', '\n', '    uint256 public totalSupply = 1000000;\n', '    uint8 public decimals = 0;\n', '\n', '    address public owner;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', ' \n', '    uint256 public totalPayments;\n', '    mapping(address => uint256) public payments;\n', '\n', '    bool public paused = false;\n', '\n', '    uint256 reclaimAmount;\n', '\n', '    event Burn(address indexed burner, uint indexed value);\n', '    event Mint(address indexed to, uint256 amount);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event PaymentForTest(address indexed to, uint256 amount);\n', '    event WithdrawPaymentForTest(address indexed to, uint256 amount);\n', '\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function CryptoTestToken() {\n', '        owner = msg.sender;\n', '        balances[owner] = 1000000;\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256 total) {\n', '        return totalSupply;\n', '    }\n', '\n', '    function balanceOf(address _who) constant returns (uint256 balance) {\n', '        return balances[_who];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) whenNotPaused returns (bool success) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool success) {\n', '        require(_to != address(0));\n', '\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) whenNotPaused returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) whenNotPaused returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) whenNotPaused returns (bool success) {\n', '\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint _value) returns (bool success)\n', '    {\n', '        require(_value > 0);\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        Burn(burner, _value);\n', '        return true;\n', '    }\n', '\n', '    function mint(address _to, uint256 _amount) onlyOwner returns (bool success) {\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Mint(_to, _amount);\n', '        Transfer(0x0, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function () payable {\n', '\n', '    }\n', '\n', '    function pause() onlyOwner whenNotPaused {\n', '        paused = true;\n', '        Pause();\n', '    }\n', '\n', '    function unpause() onlyOwner whenPaused {\n', '        paused = false;\n', '        Unpause();\n', '    }\n', '\n', '    function destroy() onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    function reclaimToken(ERC20Interface token) external onlyOwner {\n', '        reclaimAmount = token.balanceOf(this);\n', '        token.transfer(owner, reclaimAmount);\n', '        reclaimAmount = 0;\n', '    }\n', '\n', '    function asyncSend(address _to, uint256 _amount) onlyOwner {\n', '        payments[_to] = payments[_to].add(_amount);\n', '        totalPayments = totalPayments.add(_amount);\n', '        PaymentForTest(_to, _amount);\n', '    }\n', '\n', '    function withdrawPayments() {\n', '        address payee = msg.sender;\n', '        uint256 payment = payments[payee];\n', '\n', '        require(payment != 0);\n', '        require(this.balance >= payment);\n', '\n', '        totalPayments = totalPayments.sub(payment);\n', '        payments[payee] = 0;\n', '\n', '        payee.transfer(payment);\n', '        WithdrawPaymentForTest(msg.sender, payment);\n', '    }\n', '\n', '    function withdrawToAdress(address _to, uint256 _amount) onlyOwner {\n', '        require(_to != address(0));\n', '        require(this.balance >= _amount);\n', '        _to.transfer(_amount);\n', '    }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']