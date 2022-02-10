['/* The Burner v1.0, Main-Net release.\n', '*  ~by Gluedog \n', '*  -----------\n', '*\n', '*  Compiler version: 0.4.19+commit.c4cbbb05.Emscripten.clang\n', '*\n', '* The Burner is Billionaire Token\'s version of a "Faucet" - an evil, twisted Faucet. \n', '* Just like a Faucet, people can use it to get some extra coins. \n', '* Unlike a Faucet, the Burner will also burn coins and reduce the maximum supply in the process of giving people extra coins.\n', "* The Burner is only usable by addresses who have also participated in the last week's Raffle round.\n", '*/\n', '\n', 'pragma solidity ^0.4.8;\n', '\n', 'contract XBL_ERC20Wrapper\n', '{\n', '    function transferFrom(address from, address to, uint value) returns (bool success);\n', '    function transfer(address _to, uint _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    function burn(uint256 _value) returns (bool success);\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function totalSupply() constant returns (uint256 total_supply);\n', '    function burnFrom(address _from, uint256 _value) returns (bool success);\n', '}\n', '\n', 'contract XBL_RaffleWrapper\n', '{\n', '    function getLastWeekStake(address user_addr) public returns (uint256 last_week_stake);\n', '    function reduceLastWeekStake(address user_addr, uint256 amount) public;\n', '}\n', '\n', 'contract TheBurner\n', '{\n', '    uint256 DECIMALS = 1000000000000000000;\n', '\n', '    XBL_ERC20Wrapper ERC20_CALLS;\n', '    XBL_RaffleWrapper RAFFLE_CALLS;\n', '\n', '    uint8 public extra_bonus; /* The percentage of extra coins that the burner will reward people for. */\n', '\n', '    address public burner_addr;\n', '    address public raffle_addr;\n', '    address owner_addr;\n', '    address XBLContract_addr;\n', '\n', '    function TheBurner()\n', '    {\n', '        XBLContract_addr = 0x49AeC0752E68D0282Db544C677f6BA407BA17ED7;\n', '        raffle_addr = 0x0; /* Do we have a raffle address? */\n', '        extra_bonus = 5; /* 5% reward for burning your own coins, provided the burner has enough. */\n', '        burner_addr = address(this);\n', '        owner_addr = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() \n', '    {\n', '        require (msg.sender == owner_addr);\n', '        _;\n', '    }\n', '\n', '    function setRaffleAddress(address _raffle_addr) public onlyOwner\n', '    {   /* Allows the owner to set the raffle address */\n', '        raffle_addr = _raffle_addr;\n', '        RAFFLE_CALLS = XBL_RaffleWrapper(raffle_addr);\n', '    }\n', '\n', '    function getPercent(uint8 percent, uint256 number) private returns (uint256 result)\n', '    {\n', '        return number * percent / 100;\n', '    }\n', '\n', '    function registerBurn(uint256 user_input) returns (int8 registerBurn_STATUS)\n', '    {   /* This function will take a number as input, make it 18 decimal format, burn the tokens, \n', '            and give them back to the user plus 5% - if he is elligible of course.\n', '        */\n', '        uint256 tokens_registered = user_input*DECIMALS; /* 18 Decimals */\n', '        require (ERC20_CALLS.allowance(msg.sender, burner_addr) >= tokens_registered); /* Did the user pre-allow enough tokens ? */\n', "        require (tokens_registered <= RAFFLE_CALLS.getLastWeekStake(msg.sender)); /* Did the user have enough tickets in last week's Raffle ? */\n", '        uint256 eligible_reward = tokens_registered + getPercent(extra_bonus, tokens_registered);\n', '        require (eligible_reward <= ERC20_CALLS.balanceOf(burner_addr)); /* Do we have enough tokens to give out? */\n', '\n', '        /* Burn their tokens and give them their reward */\n', '        ERC20_CALLS.burnFrom(msg.sender, tokens_registered);\n', '        ERC20_CALLS.transfer(msg.sender, eligible_reward);\n', '\n', "        /* We have to reduce the users last_week_stake so that they can't burn all of the tokens, just the ones they contributed to the Raffle. */\n", '        RAFFLE_CALLS.reduceLastWeekStake(msg.sender, tokens_registered);\n', '\n', '        return 0;\n', '    }\n', '\n', '\n', '    /* <<<--- Debug ONLY functions. --->>> */\n', '    /* <<<--- Debug ONLY functions. --->>> */\n', '    /* <<<--- Debug ONLY functions. --->>> */\n', '\n', '    function dSET_XBL_ADDRESS(address _XBLContract_addr) public onlyOwner\n', '    {/* Debugging purposes. This will be hardcoded in the deployable version. */\n', '        XBLContract_addr = _XBLContract_addr;\n', '        ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);\n', '    }\n', '}']