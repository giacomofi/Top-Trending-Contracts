['pragma solidity ^0.4.24;\n', '\n', '// &#39;EVERID&#39; token contract\n', '//\n', '// Deployed to : 0xb2c19E757f60fC874D1f6dfeAD59F5bdC45Caf50\n', '// Symbol      : ID\n', '// Name        : Everest ID\n', '// Total supply: 24,000,000,000\n', '// Decimals    : 18\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract ID {\n', '    // Public variables of the token\n', '    string public name = "Tolar Token";\n', '    string public symbol = "ID";\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default\n', '    uint256 public totalSupply;\n', '    uint256 public tokenSupply = 24000000000;\n', '    uint256 public buyPrice = 500000;\n', '    address public creator;\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '    \n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function ID() public {\n', '        totalSupply = tokenSupply * 24 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens\n', '        creator = msg.sender;\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '      \n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    \n', '    \n', '    /// @notice Buy tokens from contract by sending ether\n', '    function () payable internal {\n', '        uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI\n', '        uint amountRaised;                                     \n', '        amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl\n', '        require(balanceOf[creator] >= amount);               // checks if it has enough to sell\n', '        balanceOf[msg.sender] += amount;                  // adds the amount to buyer&#39;s balance\n', '        balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint\n', '        Transfer(creator, msg.sender, amount);               // execute an event reflecting the change\n', '        creator.transfer(amountRaised);\n', '    }\n', '\n', ' }']
['pragma solidity ^0.4.24;\n', '\n', "// 'EVERID' token contract\n", '//\n', '// Deployed to : 0xb2c19E757f60fC874D1f6dfeAD59F5bdC45Caf50\n', '// Symbol      : ID\n', '// Name        : Everest ID\n', '// Total supply: 24,000,000,000\n', '// Decimals    : 18\n', '\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract ID {\n', '    // Public variables of the token\n', '    string public name = "Tolar Token";\n', '    string public symbol = "ID";\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default\n', '    uint256 public totalSupply;\n', '    uint256 public tokenSupply = 24000000000;\n', '    uint256 public buyPrice = 500000;\n', '    address public creator;\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event FundTransfer(address backer, uint amount, bool isContribution);\n', '    \n', '    \n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function ID() public {\n', '        totalSupply = tokenSupply * 24 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;    // Give DatBoiCoin Mint the total created tokens\n', '        creator = msg.sender;\n', '    }\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '      \n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    \n', '    \n', '    /// @notice Buy tokens from contract by sending ether\n', '    function () payable internal {\n', '        uint amount = msg.value * buyPrice;                    // calculates the amount, made it so you can get many BOIS but to get MANY BOIS you have to spend ETH and not WEI\n', '        uint amountRaised;                                     \n', '        amountRaised += msg.value;                            //many thanks bois, couldnt do it without r/me_irl\n', '        require(balanceOf[creator] >= amount);               // checks if it has enough to sell\n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", '        balanceOf[creator] -= amount;                        // sends ETH to DatBoiCoinMint\n', '        Transfer(creator, msg.sender, amount);               // execute an event reflecting the change\n', '        creator.transfer(amountRaised);\n', '    }\n', '\n', ' }']
