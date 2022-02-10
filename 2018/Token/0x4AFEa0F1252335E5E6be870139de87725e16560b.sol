['pragma solidity ^0.4.22;\n', '\n', '//Math operations with safety checks that throw on error\n', '\n', 'library SafeMath {\n', '\n', '    //multiply\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '    //divide\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    //subtract\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    //addition\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public contractOwner;\n', '\n', '    event TransferredOwnership(address indexed _previousOwner, address indexed _newOwner);\n', '\n', '    constructor() public {        \n', '        contractOwner = msg.sender;\n', '    }\n', '\n', '    modifier ownerOnly() {\n', '        require(msg.sender == contractOwner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) internal ownerOnly {\n', '        require(_newOwner != address(0));\n', '        contractOwner = _newOwner;\n', '\n', '        emit TransferredOwnership(contractOwner, _newOwner);\n', '    }\n', '\n', '}\n', '\n', '// Natmin vesting contract for team members\n', 'contract NatminVesting is Ownable {\n', '    struct Vesting {        \n', '        uint256 amount;\n', '        uint256 endTime;\n', '    }\n', '    mapping(address => Vesting) internal vestings;\n', '\n', '    function addVesting(address _user, uint256 _amount) public ;\n', '    function getVestedAmount(address _user) public view returns (uint256 _amount);\n', '    function getVestingEndTime(address _user) public view returns (uint256 _endTime);\n', '    function vestingEnded(address _user) public view returns (bool) ;\n', '    function endVesting(address _user) public ;\n', '}\n', '\n', '//ERC20 Standard interface specification\n', 'contract ERC20Standard {\n', '    function balanceOf(address _user) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '//ERC223 Standard interface specification\n', 'contract ERC223Standard {\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);\n', '    event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);\n', '}\n', '\n', '//ERC223 function to handle incoming token transfers\n', 'contract ERC223ReceivingContract { \n', '    function tokenFallback(address _from, uint256 _value, bytes _data) public pure {\n', '        _from;\n', '        _value;\n', '        _data;\n', '    }\n', '}\n', '\n', 'contract BurnToken is Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    function burn(uint256 _value) public;\n', '    function _burn(address _user, uint256 _value) internal;\n', '    event Burn(address indexed _user, uint256 _value);\n', '}\n', '\n', '//NatminToken implements the ERC20, ERC223 standard methods\n', 'contract NatminToken is ERC20Standard, ERC223Standard, Ownable, NatminVesting, BurnToken {\n', '    using SafeMath for uint256;\n', '\n', '    string _name = "Natmin";\n', '    string _symbol = "NAT";\n', '    string _standard = "ERC20 / ERC223";\n', '    uint256 _decimals = 18; // same value as wei\n', '    uint256 _totalSupply;\n', '\n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\n', '    constructor(uint256 _supply) public {\n', '        require(_supply != 0);\n', '        _totalSupply = _supply * (10 ** 18);\n', '        balances[contractOwner] = _totalSupply;\n', '    }\n', '\n', '    // Returns the _name of the token\n', '    function name() public view returns (string) {\n', '        return _name;        \n', '    }\n', '\n', '    // Returns the _symbol of the token\n', '    function symbol() public view returns (string) {\n', '        return _symbol;\n', '    }\n', '\n', '    // Returns the _standard of the token\n', '    function standard() public view returns (string) {\n', '        return _standard;\n', '    }\n', '\n', '    // Returns the _decimals of the token\n', '    function decimals() public view returns (uint256) {\n', '        return _decimals;\n', '    }\n', '\n', '    // Function to return the total supply of the token\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    // Function to return the balance of a specified address\n', '    function balanceOf(address _user) public view returns (uint256 balance){\n', '        return balances[_user];\n', '    }   \n', '\n', '    // Transfer function to be compatable with ERC20 Standard\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        bytes memory _empty;\n', '        if(isContract(_to)){\n', '            return transferToContract(_to, _value, _empty);\n', '        }else{\n', '            return transferToAddress(_to, _value, _empty);\n', '        }\n', '    }\n', '\n', '    // Transfer function to be compatable with ERC223 Standard\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {\n', '        if(isContract(_to)){\n', '            return transferToContract(_to, _value, _data);\n', '        }else{\n', '            return transferToAddress(_to, _value, _data);\n', '        }\n', '    }\n', '\n', '    // This function checks if the address is a contract or wallet\n', '    // If the codeLength is greater than 0, it is a contract\n', '    function isContract(address _to) internal view returns (bool) {\n', '        uint256 _codeLength;\n', '\n', '        assembly {\n', '            _codeLength := extcodesize(_to)\n', '        }\n', '\n', '        return _codeLength > 0;\n', '    }\n', '\n', '    // This function to be used if the target is a contract address\n', '    function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {\n', '        require(balances[msg.sender] >= _value);\n', '        require(vestingEnded(msg.sender));\n', '        \n', '        // This will override settings and allow contract owner to send to contract\n', '        if(msg.sender != contractOwner){\n', '            ERC223ReceivingContract _tokenReceiver = ERC223ReceivingContract(_to);\n', '            _tokenReceiver.tokenFallback(msg.sender, _value, _data);\n', '        }\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // This function to be used if the target is a normal eth/wallet address \n', '    function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {\n', '        require(balances[msg.sender] >= _value);\n', '        require(vestingEnded(msg.sender));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '        return true;\n', '    }\n', '\n', '    // ERC20 standard function\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(_value <= balances[_from]);\n', '        require(vestingEnded(_from));\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    // ERC20 standard function\n', '    function approve(address _spender, uint256 _value) public returns (bool success){\n', '        allowed[msg.sender][_spender] = 0;\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    // ERC20 standard function\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // Stops any attempt from sending Ether to this contract\n', '    function () public {\n', '        revert();\n', '    }\n', '\n', '    // public function to call the _burn function \n', '    function burn(uint256 _value) public ownerOnly {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    // Burn the specified amount of tokens by the owner\n', '    function _burn(address _user, uint256 _value) internal ownerOnly {\n', '        require(balances[_user] >= _value);\n', '\n', '        balances[_user] = balances[_user].sub(_value);\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        \n', '        emit Burn(_user, _value);\n', '        emit Transfer(_user, address(0), _value);\n', '\n', '        bytes memory _empty;\n', '        emit Transfer(_user, address(0), _value, _empty);\n', '    }\n', '\n', '    // Create a vesting entry for the specified user\n', '    function addVesting(address _user, uint256 _amount) public ownerOnly {\n', '        vestings[_user].amount = _amount;\n', '        vestings[_user].endTime = now + 180 days;\n', '    }\n', '\n', '    // Returns the vested amount for a specified user\n', '    function getVestedAmount(address _user) public view returns (uint256 _amount) {\n', '        _amount = vestings[_user].amount;\n', '        return _amount;\n', '    }\n', '\n', '    // Returns the vested end time for a specified user\n', '    function getVestingEndTime(address _user) public view returns (uint256 _endTime) {\n', '        _endTime = vestings[_user].endTime;\n', '        return _endTime;\n', '    }\n', '\n', '    // Checks if the venting period is over for a specified user\n', '    function vestingEnded(address _user) public view returns (bool) {\n', '        if(vestings[_user].endTime <= now) {\n', '            return true;\n', '        }\n', '        else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    // Manual end vested time \n', '    function endVesting(address _user) public ownerOnly {\n', '        vestings[_user].endTime = now;\n', '    }\n', '}']