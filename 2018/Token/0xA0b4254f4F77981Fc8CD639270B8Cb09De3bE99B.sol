['pragma solidity ^0.4.18;\n', '\n', '    contract owned {\n', '        address public owner;\n', '\n', '        constructor() owned() internal {\n', '            owner = msg.sender;\n', '        }\n', '\n', '        modifier onlyOwner {\n', '            require(msg.sender == owner);\n', '            _;\n', '        }\n', '\n', '        function transferOwnership(address newOwner) onlyOwner internal {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '    \n', '    interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }\n', '\n', '    contract apecashToken is owned {\n', '         string public name;\n', 'string public symbol;\n', 'uint8 public decimals;\n', '        \n', '        /* This creates an array with all balances */\n', '        mapping (address => uint256) public balanceOf;\n', '        \n', '            event Transfer(address indexed from, address indexed to, uint256 value);\n', '        // This generates a public event on the blockchain that will notify clients\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '        \n', '        /* Initializes contract with initial supply tokens to the creator of the contract */\n', '        \n', '    constructor(uint256 totalSupply, string tokenName, string tokenSymbol) public {\n', '        totalSupply = 100000000000000000000000000;  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = 100000000000000000000000000;                // Give the creator all initial tokens\n', '        name = tokenName;                                   // Set the name for display purposes\n', '        symbol = tokenSymbol;                               // Set the symbol for display purposes\n', '        decimals = 18;                            // Amount of decimals for display purposes\n', '    }\n', '    \n', '\n', '        /* Send coins */\n', '        function transfer(address _to, uint256 _value) public {\n', '        /* Check if sender has balance and for overflows */\n', '        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        /* Add and subtract new balances */\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        \n', '                /* Notify anyone listening that this transfer took place */\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '    \n', '      /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '    \n', '  \n', '    \n', '    }']