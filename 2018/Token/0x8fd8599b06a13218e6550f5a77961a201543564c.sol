['pragma solidity ^0.4.25;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        totalSupply = 12000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "DCETHER";                                   // Set the name for display purposes\n', '        symbol = "DCETH";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', 'contract  DCETHER is owned, TokenERC20 {\n', '    \n', '    uint public sale_step;\n', '    \n', '    address dcether_corp;\n', '    address public Coin_manager;\n', '\n', '    mapping (address => address) public followup;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() TokenERC20()  public \n', '    {\n', '        sale_step = 0;  // 0 : No sale, 1 : Presale, 2 : Crowdsale, 3 : Normalsale \n', '        dcether_corp = msg.sender;\n', '        Coin_manager = 0x0;\n', '    }\n', '    \n', '    function SetCoinManager(address manager) onlyOwner public\n', '    {\n', '        require(manager != 0x0);\n', '        \n', '        uint amount = balanceOf[dcether_corp];\n', '        \n', '        Coin_manager = manager;\n', '        balanceOf[Coin_manager] += amount;\n', '        balanceOf[dcether_corp] = 0;\n', '        Transfer(dcether_corp, Coin_manager, amount);               // execute an event reflecting the change\n', '    }\n', '    \n', '    function SetSaleStep(uint256 step) onlyOwner public\n', '    {\n', '        sale_step = step;\n', '    }\n', '\n', '    function () payable public\n', '    {\n', '        require(sale_step!=0);\n', '\n', '        uint nowprice = 10000;   // Token Price per ETher\n', '        address follower_1st = 0x0; // 1st follower\n', '        address follower_2nd = 0x0; // 2nd follower\n', '        \n', '        uint amount = 0;    // Total token buyed\n', '        uint amount_1st = 0;    // Bonus token for 1st follower\n', '        uint amount_2nd = 0;    // Bonus token for 2nd follower\n', '        uint all_amount = 0;\n', '\n', '        amount = msg.value * nowprice;  \n', '        \n', '        follower_1st = followup[msg.sender];\n', '        \n', '        if ( follower_1st != 0x0 )\n', '        {\n', '            amount_1st = amount;    // 100% bonus give to 1st follower\n', '            if ( balanceOf[follower_1st] < amount_1st ) // if he has smaller than bonus\n', '                amount_1st = balanceOf[follower_1st];   // cannot get bonus all\n', '                \n', '            follower_2nd = followup[follower_1st];\n', '            \n', '            if ( follower_2nd != 0x0 )\n', '            {\n', '                amount_2nd = amount / 2;    // 50% bonus give to 2nd follower\n', '                \n', '                if ( balanceOf[follower_2nd] < amount_2nd ) // if he has smaller than bonus\n', '                amount_2nd = balanceOf[follower_2nd];   // cannot get bonus all\n', '            }\n', '        }\n', '        \n', '        all_amount = amount + amount_1st + amount_2nd;\n', '            \n', '        address manager = Coin_manager;\n', '        \n', '        if ( manager == 0x0 )\n', '            manager = dcether_corp;\n', '        \n', '        require(balanceOf[manager]>=all_amount);\n', '        \n', '        require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);\n', '        balanceOf[manager] -= amount;\n', '        balanceOf[msg.sender] += amount;                  // adds the amount to buyer&#39;s balance\n', '        require(manager.send(msg.value));\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '\n', '        if ( amount_1st > 0 )   // first follower give bonus\n', '        {\n', '            require(balanceOf[follower_1st] + amount_1st > balanceOf[follower_1st]);\n', '            \n', '            balanceOf[manager] -= amount_1st;\n', '            balanceOf[follower_1st] += amount_1st;                  // adds the amount to buyer&#39;s balance\n', '            \n', '            Transfer(this, follower_1st, amount_1st);               // execute an event reflecting the change\n', '        }\n', '\n', '        if ( amount_2nd > 0 )   // second follower give bonus\n', '        {\n', '            require(balanceOf[follower_2nd] + amount_2nd > balanceOf[follower_2nd]);\n', '            \n', '            balanceOf[manager] -= amount_2nd;\n', '            balanceOf[follower_2nd] += amount_2nd;                  // adds the amount to buyer&#39;s balance\n', '            \n', '            Transfer(this, follower_2nd, amount_2nd);               // execute an event reflecting the change\n', '        }\n', '    }\n', '\n', '    function BuyFromFollower(address follow_who) payable public\n', '    {\n', '        require(sale_step!=0);\n', '\n', '        uint nowprice = 10000;   // Token Price per ETher\n', '        address follower_1st = 0x0; // 1st follower\n', '        address follower_2nd = 0x0; // 2nd follower\n', '        \n', '        uint amount = 0;    // Total token buyed\n', '        uint amount_1st = 0;    // Bonus token for 1st follower\n', '        uint amount_2nd = 0;    // Bonus token for 2nd follower\n', '        uint all_amount = 0;\n', '\n', '        amount = msg.value * nowprice;  \n', '        \n', '        follower_1st = follow_who;\n', '        followup[msg.sender] = follower_1st;\n', '        \n', '        if ( follower_1st != 0x0 )\n', '        {\n', '            amount_1st = amount;    // 100% bonus give to 1st follower\n', '            if ( balanceOf[follower_1st] < amount_1st ) // if he has smaller than bonus\n', '                amount_1st = balanceOf[follower_1st];   // cannot get bonus all\n', '                \n', '            follower_2nd = followup[follower_1st];\n', '            \n', '            if ( follower_2nd != 0x0 )\n', '            {\n', '                amount_2nd = amount / 2;    // 50% bonus give to 2nd follower\n', '                \n', '                if ( balanceOf[follower_2nd] < amount_2nd ) // if he has smaller than bonus\n', '                amount_2nd = balanceOf[follower_2nd];   // cannot get bonus all\n', '            }\n', '        }\n', '        \n', '        all_amount = amount + amount_1st + amount_2nd;\n', '            \n', '        address manager = Coin_manager;\n', '        \n', '        if ( manager == 0x0 )\n', '            manager = dcether_corp;\n', '        \n', '        require(balanceOf[manager]>=all_amount);\n', '        \n', '        require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);\n', '        balanceOf[manager] -= amount;\n', '        balanceOf[msg.sender] += amount;                  // adds the amount to buyer&#39;s balance\n', '        require(manager.send(msg.value));\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '\n', '        if ( amount_1st > 0 )   // first follower give bonus\n', '        {\n', '            require(balanceOf[follower_1st] + amount_1st > balanceOf[follower_1st]);\n', '            \n', '            balanceOf[manager] -= amount_1st;\n', '            balanceOf[follower_1st] += amount_1st;                  // adds the amount to buyer&#39;s balance\n', '            \n', '            Transfer(this, follower_1st, amount_1st);               // execute an event reflecting the change\n', '        }\n', '\n', '        if ( amount_2nd > 0 )   // second follower give bonus\n', '        {\n', '            require(balanceOf[follower_2nd] + amount_2nd > balanceOf[follower_2nd]);\n', '            \n', '            balanceOf[manager] -= amount_2nd;\n', '            balanceOf[follower_2nd] += amount_2nd;                  // adds the amount to buyer&#39;s balance\n', '            \n', '            Transfer(this, follower_2nd, amount_2nd);               // execute an event reflecting the change\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Owner can move ChalletValue from backers to another forcely\n', '     *\n', '     * @param _from The address of backers who send ChalletValue\n', '     * @param _to The address of backers who receive ChalletValue\n', '     * @param amount How many ChalletValue will buy back from him\n', '     */\n', '    function ForceCoinTransfer(address _from, address _to, uint amount) onlyOwner public\n', '    {\n', '        uint coin_amount = amount * 10 ** uint256(decimals);\n', '\n', '        require(_from != 0x0);\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= coin_amount);         // checks if the sender has enough to sell\n', '\n', '        balanceOf[_from] -= coin_amount;                  // subtracts the amount from seller&#39;s balance\n', '        balanceOf[_to] += coin_amount;                  // subtracts the amount from seller&#39;s balance\n', '        Transfer(_from, _to, coin_amount);               // executes an event reflecting on the change\n', '    }\n', '\n', '    /**\n', '     * Owner will buy back ChalletValue from backers\n', '     *\n', '     * @param _from The address of backers who have ChalletValue\n', '     * @param coin_amount How many ChalletValue will buy back from him\n', '     */\n', '    function DestroyCoin(address _from, uint256 coin_amount) onlyOwner public \n', '    {\n', '        uint256 amount = coin_amount * 10 ** uint256(decimals);\n', '\n', '        require(balanceOf[_from] >= amount);         // checks if the sender has enough to sell\n', '        balanceOf[_from] -= amount;                  // subtracts the amount from seller&#39;s balance\n', '        Transfer(_from, this, amount);               // executes an event reflecting on the change\n', '    }    \n', '    \n', '\n', '}']
['pragma solidity ^0.4.25;\n', '\n', 'contract owned {\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', 'contract TokenERC20 {\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    // 18 decimals is the strongly suggested default, avoid changing it\n', '    uint256 public totalSupply;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    constructor() public {\n', '        totalSupply = 12000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount\n', '        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens\n', '        name = "DCETHER";                                   // Set the name for display purposes\n', '        symbol = "DCETH";                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     */\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        // Subtract from the sender\n', '        balanceOf[_from] -= _value;\n', '        // Add the same to the recipient\n', '        balanceOf[_to] += _value;\n', '        Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', 'contract  DCETHER is owned, TokenERC20 {\n', '    \n', '    uint public sale_step;\n', '    \n', '    address dcether_corp;\n', '    address public Coin_manager;\n', '\n', '    mapping (address => address) public followup;\n', '\n', '    /* Initializes contract with initial supply tokens to the creator of the contract */\n', '    constructor() TokenERC20()  public \n', '    {\n', '        sale_step = 0;  // 0 : No sale, 1 : Presale, 2 : Crowdsale, 3 : Normalsale \n', '        dcether_corp = msg.sender;\n', '        Coin_manager = 0x0;\n', '    }\n', '    \n', '    function SetCoinManager(address manager) onlyOwner public\n', '    {\n', '        require(manager != 0x0);\n', '        \n', '        uint amount = balanceOf[dcether_corp];\n', '        \n', '        Coin_manager = manager;\n', '        balanceOf[Coin_manager] += amount;\n', '        balanceOf[dcether_corp] = 0;\n', '        Transfer(dcether_corp, Coin_manager, amount);               // execute an event reflecting the change\n', '    }\n', '    \n', '    function SetSaleStep(uint256 step) onlyOwner public\n', '    {\n', '        sale_step = step;\n', '    }\n', '\n', '    function () payable public\n', '    {\n', '        require(sale_step!=0);\n', '\n', '        uint nowprice = 10000;   // Token Price per ETher\n', '        address follower_1st = 0x0; // 1st follower\n', '        address follower_2nd = 0x0; // 2nd follower\n', '        \n', '        uint amount = 0;    // Total token buyed\n', '        uint amount_1st = 0;    // Bonus token for 1st follower\n', '        uint amount_2nd = 0;    // Bonus token for 2nd follower\n', '        uint all_amount = 0;\n', '\n', '        amount = msg.value * nowprice;  \n', '        \n', '        follower_1st = followup[msg.sender];\n', '        \n', '        if ( follower_1st != 0x0 )\n', '        {\n', '            amount_1st = amount;    // 100% bonus give to 1st follower\n', '            if ( balanceOf[follower_1st] < amount_1st ) // if he has smaller than bonus\n', '                amount_1st = balanceOf[follower_1st];   // cannot get bonus all\n', '                \n', '            follower_2nd = followup[follower_1st];\n', '            \n', '            if ( follower_2nd != 0x0 )\n', '            {\n', '                amount_2nd = amount / 2;    // 50% bonus give to 2nd follower\n', '                \n', '                if ( balanceOf[follower_2nd] < amount_2nd ) // if he has smaller than bonus\n', '                amount_2nd = balanceOf[follower_2nd];   // cannot get bonus all\n', '            }\n', '        }\n', '        \n', '        all_amount = amount + amount_1st + amount_2nd;\n', '            \n', '        address manager = Coin_manager;\n', '        \n', '        if ( manager == 0x0 )\n', '            manager = dcether_corp;\n', '        \n', '        require(balanceOf[manager]>=all_amount);\n', '        \n', '        require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);\n', '        balanceOf[manager] -= amount;\n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", '        require(manager.send(msg.value));\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '\n', '        if ( amount_1st > 0 )   // first follower give bonus\n', '        {\n', '            require(balanceOf[follower_1st] + amount_1st > balanceOf[follower_1st]);\n', '            \n', '            balanceOf[manager] -= amount_1st;\n', "            balanceOf[follower_1st] += amount_1st;                  // adds the amount to buyer's balance\n", '            \n', '            Transfer(this, follower_1st, amount_1st);               // execute an event reflecting the change\n', '        }\n', '\n', '        if ( amount_2nd > 0 )   // second follower give bonus\n', '        {\n', '            require(balanceOf[follower_2nd] + amount_2nd > balanceOf[follower_2nd]);\n', '            \n', '            balanceOf[manager] -= amount_2nd;\n', "            balanceOf[follower_2nd] += amount_2nd;                  // adds the amount to buyer's balance\n", '            \n', '            Transfer(this, follower_2nd, amount_2nd);               // execute an event reflecting the change\n', '        }\n', '    }\n', '\n', '    function BuyFromFollower(address follow_who) payable public\n', '    {\n', '        require(sale_step!=0);\n', '\n', '        uint nowprice = 10000;   // Token Price per ETher\n', '        address follower_1st = 0x0; // 1st follower\n', '        address follower_2nd = 0x0; // 2nd follower\n', '        \n', '        uint amount = 0;    // Total token buyed\n', '        uint amount_1st = 0;    // Bonus token for 1st follower\n', '        uint amount_2nd = 0;    // Bonus token for 2nd follower\n', '        uint all_amount = 0;\n', '\n', '        amount = msg.value * nowprice;  \n', '        \n', '        follower_1st = follow_who;\n', '        followup[msg.sender] = follower_1st;\n', '        \n', '        if ( follower_1st != 0x0 )\n', '        {\n', '            amount_1st = amount;    // 100% bonus give to 1st follower\n', '            if ( balanceOf[follower_1st] < amount_1st ) // if he has smaller than bonus\n', '                amount_1st = balanceOf[follower_1st];   // cannot get bonus all\n', '                \n', '            follower_2nd = followup[follower_1st];\n', '            \n', '            if ( follower_2nd != 0x0 )\n', '            {\n', '                amount_2nd = amount / 2;    // 50% bonus give to 2nd follower\n', '                \n', '                if ( balanceOf[follower_2nd] < amount_2nd ) // if he has smaller than bonus\n', '                amount_2nd = balanceOf[follower_2nd];   // cannot get bonus all\n', '            }\n', '        }\n', '        \n', '        all_amount = amount + amount_1st + amount_2nd;\n', '            \n', '        address manager = Coin_manager;\n', '        \n', '        if ( manager == 0x0 )\n', '            manager = dcether_corp;\n', '        \n', '        require(balanceOf[manager]>=all_amount);\n', '        \n', '        require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);\n', '        balanceOf[manager] -= amount;\n', "        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance\n", '        require(manager.send(msg.value));\n', '        Transfer(this, msg.sender, amount);               // execute an event reflecting the change\n', '\n', '        if ( amount_1st > 0 )   // first follower give bonus\n', '        {\n', '            require(balanceOf[follower_1st] + amount_1st > balanceOf[follower_1st]);\n', '            \n', '            balanceOf[manager] -= amount_1st;\n', "            balanceOf[follower_1st] += amount_1st;                  // adds the amount to buyer's balance\n", '            \n', '            Transfer(this, follower_1st, amount_1st);               // execute an event reflecting the change\n', '        }\n', '\n', '        if ( amount_2nd > 0 )   // second follower give bonus\n', '        {\n', '            require(balanceOf[follower_2nd] + amount_2nd > balanceOf[follower_2nd]);\n', '            \n', '            balanceOf[manager] -= amount_2nd;\n', "            balanceOf[follower_2nd] += amount_2nd;                  // adds the amount to buyer's balance\n", '            \n', '            Transfer(this, follower_2nd, amount_2nd);               // execute an event reflecting the change\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * Owner can move ChalletValue from backers to another forcely\n', '     *\n', '     * @param _from The address of backers who send ChalletValue\n', '     * @param _to The address of backers who receive ChalletValue\n', '     * @param amount How many ChalletValue will buy back from him\n', '     */\n', '    function ForceCoinTransfer(address _from, address _to, uint amount) onlyOwner public\n', '    {\n', '        uint coin_amount = amount * 10 ** uint256(decimals);\n', '\n', '        require(_from != 0x0);\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= coin_amount);         // checks if the sender has enough to sell\n', '\n', "        balanceOf[_from] -= coin_amount;                  // subtracts the amount from seller's balance\n", "        balanceOf[_to] += coin_amount;                  // subtracts the amount from seller's balance\n", '        Transfer(_from, _to, coin_amount);               // executes an event reflecting on the change\n', '    }\n', '\n', '    /**\n', '     * Owner will buy back ChalletValue from backers\n', '     *\n', '     * @param _from The address of backers who have ChalletValue\n', '     * @param coin_amount How many ChalletValue will buy back from him\n', '     */\n', '    function DestroyCoin(address _from, uint256 coin_amount) onlyOwner public \n', '    {\n', '        uint256 amount = coin_amount * 10 ** uint256(decimals);\n', '\n', '        require(balanceOf[_from] >= amount);         // checks if the sender has enough to sell\n', "        balanceOf[_from] -= amount;                  // subtracts the amount from seller's balance\n", '        Transfer(_from, this, amount);               // executes an event reflecting on the change\n', '    }    \n', '    \n', '\n', '}']
