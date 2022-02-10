['pragma solidity ^ 0.4.16;\n', '\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '   \n', '}\n', 'contract tokenRecipient {\n', '    function  receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract ERC20 is Ownable{\n', '    /* Public variables of the token */\n', "    string public standard = 'CREDITS';\n", "    string public name = 'CREDITS';\n", "    string public symbol = 'CS';\n", '    uint8 public decimals = 6;\n', '    uint256 public totalSupply = 1000000000000000;\n', '    bool public IsFrozen=false;\n', '    address public ICOAddress;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', ' modifier IsNotFrozen{\n', '      require(!IsFrozen||msg.sender==owner\n', '      ||msg.sender==0x0a6d9df476577C0D4A24EB50220fad007e444db8\n', '      ||msg.sender==ICOAddress);\n', '      _;\n', '  }\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    function ERC20() public {\n', '        balanceOf[msg.sender] = totalSupply;\n', '    }\n', '    function setICOAddress(address _address) public onlyOwner{\n', '        ICOAddress=_address;\n', '    }\n', '    \n', '   function setIsFrozen(bool _IsFrozen)public onlyOwner{\n', '      IsFrozen=_IsFrozen;\n', '    }\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public IsNotFrozen {\n', '        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows\n', '        balanceOf[msg.sender] -= _value; // Subtract from the sender\n', '        balanceOf[_to] += _value; // Add the same to the recipient\n', '        Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place\n', '    }\n', '  \n', ' \n', '    /* Allow another contract to spend some tokens in your behalf */\n', '    function approve(address _spender, uint256 _value)public\n', '    returns(bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then comunicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public\n', '    returns(bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value)public IsNotFrozen returns(bool success)  {\n', '        require (balanceOf[_from] >= _value) ; // Check if the sender has enough\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows\n', '        require (_value <= allowance[_from][msg.sender]) ; // Check allowance\n', '      \n', '        balanceOf[_from] -= _value; // Subtract from the sender\n', '        balanceOf[_to] += _value; // Add the same to the recipient\n', '        allowance[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', ' /* @param _value the amount of money to burn*/\n', '    event Burn(address indexed from, uint256 value);\n', '    function burn(uint256 _value) public onlyOwner  returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '        balanceOf[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '     // Optional token name\n', '\n', '    \n', '    \n', '    function setName(string name_) public onlyOwner {\n', '        name = name_;\n', '    }\n', '    /* This unnamed function is called whenever someone tries to send ether to it */\n', '    function () public {\n', '     require(1==2) ; // Prevents accidental sending of ether\n', '    }\n', '}']