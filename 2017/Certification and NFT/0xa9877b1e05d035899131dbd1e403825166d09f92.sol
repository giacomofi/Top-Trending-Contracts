['pragma solidity ^0.4.18;\n', '\n', '// https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint256 supply);\n', '    function balanceOf(address _owner) public constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);\n', '    \n', '    // These generate a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '}\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract MNTToken is ERC20, Owned {\n', '    // Public variables of the token\n', '    string public name = "Media Network Token";\n', '    string public symbol = "MNT";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 0; // 125 * 10**6 * 10**18;\n', '    uint256 public maxSupply = 125 * 10**6 * 10**18;\n', '    address public cjTeamWallet = 0x9887c2da3aC5449F3d62d4A04372a4724c21f54C;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    // This creates an array with all allowances\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '\n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Gives ownership of all initial tokens to the Coin Joker Team. Sets ownership of contract\n', '     */\n', '    function MNTToken(\n', '        address cjTeam\n', '    ) public {\n', '        //balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens\n', '        totalEthRaised = 0;\n', '        /*if (cjTeam != 0) {\n', '            owner = cjTeam;\n', '        }*/\n', '        cjTeamWallet = cjTeam;\n', '    }\n', '\t\n', '    function changeCJTeamWallet(address newWallet) public onlyOwner {\n', '        cjTeamWallet = newWallet;\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        require(_to != 0x0);                               // Prevent transfer to 0x0 address\n', '        require(balanceOf[_from] >= _value);                // Check if the sender has enough\n', '        require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        balanceOf[_from] -= _value;                         // Subtract from the sender\n', '        balanceOf[_to] += _value;                           // Add the same to the recipient\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(\n', '        address _from, \n', '        address _to, \n', '        uint256 _value\n', '    ) public returns (bool success) \n', '    {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(\n', '        address _spender, \n', '        uint256 _value\n', '    ) public returns (bool success)\n', '    {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Get current balance of account _owner\n', '     *\n', '     * @param _owner The owner of the account\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    /**\n', '     * Get allowance from _owner to _spender\n', '     *\n', '     * @param _owner The address that authorizes to spend\n', '     * @param _spender The address authorized to spend\n', '     */\n', '    function allowance(\n', '        address _owner, \n', '        address _spender\n', '    ) public constant returns (uint256 remaining)\n', '    {\n', '        return allowance[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Get total supply of all tokens\n', '     */\n', '    function totalSupply() public constant returns (uint256 supply) {\n', '        return totalSupply;\n', '    }\n', '\n', '    // --------------------------------\n', '    // Token sale variables and methods\n', '    // --------------------------------\n', '\n', '    bool saleHasStarted = false;\n', '    bool saleHasEnded = false;\n', '    uint256 public saleEndTime   = 1518649200; // 15.2.2018, 0:00:00, GMT+1\n', '    uint256 public saleStartTime = 1513435000; // 16.12.2017, 15:36:40, GMT+1\n', '    uint256 public maxEthToRaise = 7500 * 10**18;\n', '    uint256 public totalEthRaised;\n', '    uint256 public ethAvailable;\n', '    uint256 public eth2mnt = 10000; // number of MNTs you get for 1 ETH - actually for 1/10**18 of ETH\n', '\n', '    /* Issue new tokens - internal function */     \n', '    function _mintTokens (address _to, uint256 _amount) internal {             \n', '        require(balanceOf[_to] + _amount >= balanceOf[_to]); // check for overflows\n', '        require(totalSupply + _amount <= maxSupply);\n', '        totalSupply += _amount;                                      // Update total supply\n', '        balanceOf[_to] += _amount;                               // Set minted coins to target\n', '        Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x\n', '    }\n', '\n', '\n', '    /* Users send ETH and enter the token sale*/  \n', '    function () public payable {\n', '        require(msg.value != 0);\n', '        require(!(saleHasEnded || now > saleEndTime)); // Throw if the token sale has ended\n', '        if (!saleHasStarted) {                                                // Check if this is the first token sale transaction   \n', '            if (now >= saleStartTime) {                             // Check if the token sale should start        \n', '                saleHasStarted = true;                                           // Set that the token sale has started         \n', '            } else {\n', '                require(false);\n', '            }\n', '        }     \n', '     \n', '        if (maxEthToRaise > (totalEthRaised + msg.value)) {                 // Check if the user sent too much ETH         \n', '            totalEthRaised += msg.value;                                    // Add to total eth Raised\n', '            ethAvailable += msg.value;\n', '            _mintTokens(msg.sender, msg.value * eth2mnt);\n', '            cjTeamWallet.transfer(msg.value); \n', '        } else {                                                              // If user sent to much eth       \n', '            uint maxContribution = maxEthToRaise - totalEthRaised;            // Calculate maximum contribution       \n', '            totalEthRaised += maxContribution;  \n', '            ethAvailable += maxContribution;\n', '            _mintTokens(msg.sender, maxContribution * eth2mnt);\n', '            uint toReturn = msg.value - maxContribution;                       // Calculate how much should be returned       \n', '            saleHasEnded = true;\n', '            msg.sender.transfer(toReturn);                                  // Refund the balance that is over the cap   \n', '            cjTeamWallet.transfer(msg.value-toReturn);       \n', '        }\n', '    } \n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Sends the raised amount to the CJ Team. Mints 40% of tokens to send to the CJ team.\n', '     */\n', '    function endOfSaleFullWithdrawal() public onlyOwner {\n', '        if (saleHasEnded || now > saleEndTime) {\n', '            //if (owner.send(ethAvailable)) {\n', '            cjTeamWallet.transfer(this.balance);\n', '            ethAvailable = 0;\n', '            //_mintTokens (owner, totalSupply * 2 / 3);\n', '            _mintTokens (cjTeamWallet, 50 * 10**6 * 10**18); // CJ team gets 40% of token supply\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Withdraw the funds\n', '     *\n', '     * Sends partial amount to the CJ Team\n', '     */\n', '    function partialWithdrawal(uint256 toWithdraw) public onlyOwner {\n', '        cjTeamWallet.transfer(toWithdraw);\n', '        ethAvailable -= toWithdraw;\n', '    }\n', '}']