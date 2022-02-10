['pragma solidity ^0.5.2;\n', '\n', 'contract VirtuDollar {\n', '    // ERC20 standard specs\n', '    string public name = "Virtu Dollar";\n', '    string public symbol = "V$";\n', '    string public standard = "Virtu Dollar v1.0";\n', '    uint8 public decimals = 18;\n', '\n', '    // VirtuDollar total supply which is publicly visible on the ethereum blockchain.\n', '    uint256 public VDollars;\n', '\n', '    // Map for owner addresses that holds the balances.\n', '    mapping( address => uint256) public balanceOf;\n', '\n', '    // Map for owner addresses that holds the allowed addresses and remaining allowance\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    // Virtu dollar owner identity\n', '    address owner;\n', '\n', '    // The smart contract will start initially with a zero total supply\n', '    constructor(uint256 _initialSupply) public {\n', '        // Initiate the owner\n', '        owner = msg.sender;\n', '        // Update the owner balance\n', '        balanceOf[owner] = _initialSupply * 10 ** uint256(decimals);\n', '        // Mint the initial virtu dollar supply\n', '        VDollars = balanceOf[owner];\n', '    }\n', '\n', '    // Implementing the ERC 20 transfer function\n', '    function transfer (address _to, uint256 _value) public returns (bool success) {\n', '        // Require the value to be already present in the balance\n', '        require(balanceOf[msg.sender] >= _value);\n', '        // Decrement the balance of the sender\n', '        balanceOf[msg.sender] -= _value;\n', '        // Increment the balance of the recipient\n', '        balanceOf[_to] += _value;\n', '        // Fire the Transfer event\n', '        emit Transfer(msg.sender, _to, _value);\n', '        // Return the success flag\n', '        return true;\n', '    }\n', '\n', '    // Implementing the ERC 20 transfer event\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _value\n', '    );\n', '\n', '    // Implementing the ERC 20 delegated transfer function\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        // Checking the value is available in the balance\n', '        require(_value <= balanceOf[_from]);\n', '        // Checking the value is allowed\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        // Performing the transfer\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        // Decrementing the allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        // Firing the transfer event\n', '        emit Transfer(_from, _to, _value);\n', '        // Returning the success flag\n', '        return true;\n', '    }\n', '\n', '    // Implementing the ERC 20 approval event\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '\n', '    // Impelmenting the ERC 20 approve function\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        // Setting the allowance to the new amount\n', '        allowance[msg.sender][_spender] = _value;\n', '        // Firing the approval event\n', '        emit Approval(msg.sender, _spender, _value);\n', '        // Returning the success flag\n', '        return true;\n', '    }\n', '\n', '    // Implementing the Burn event\n', '    event Burn (\n', '        address indexed _from,\n', '        uint256 _value\n', '    );\n', '\n', '    // Implementing the burn function\n', '    function burn (uint256 _value) public returns (bool success) {\n', '        // Checking the owner has enough balance\n', '        require(balanceOf[msg.sender] >= _value);\n', '        // Decrementing the balance\n', '        balanceOf[msg.sender] -= _value;\n', '        // Burning the tokens\n', '        VDollars -= _value;\n', '        // Firing the burn event\n', '        emit Burn(msg.sender, _value);\n', '        // Returning the success flag\n', '        return true;\n', '    }\n', '\n', '    // Implementing the delegated burn function\n', '    function burnFrom (address _from, uint256 _value) public returns (bool success) {\n', '        // Check if the owner has enough balance\n', '        require(balanceOf[_from] >= _value);\n', '        // Check if the spender has enough allowance\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        // Decrement the owner balance\n', '        balanceOf[_from] -= _value;\n', '        // Decrement the allowance value\n', '        allowance[_from][msg.sender] -= _value;\n', '        // Burn the tokens\n', '        VDollars -= _value;\n', '        // Fire the burn event\n', '        emit Burn(_from, _value);\n', '        // Returning the success flag\n', '        return true;\n', '    }\n', '\n', '    // Implementing the Mint event\n', '    event Mint(\n', '        address indexed _from,\n', '        uint256 _value\n', '    );\n', '\n', '    // Implementing the mint function\n', '    function mint (uint256 _value) public returns (bool success) {\n', '        // Checking the owner is the owner of the coin\n', '        require(msg.sender == owner);\n', '        // Incrementing the owner balance\n', '        balanceOf[owner] += _value;\n', '        // Minting the tokens\n', '        VDollars += _value;\n', '        // Firing the mint event\n', '        emit Mint(msg.sender, _value);\n', '        // Returning the success flag\n', '        return true;\n', '    }\n', '}']