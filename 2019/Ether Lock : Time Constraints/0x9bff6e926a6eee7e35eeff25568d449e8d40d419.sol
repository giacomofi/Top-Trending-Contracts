['pragma solidity ^0.5.2;\n', '\n', '\n', 'contract XBL_ERC20Wrapper\n', '{\n', '    function transferFrom(address from, address to, uint value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public  returns (uint256 remaining);\n', '    function balanceOf(address _owner) public returns (uint256 balance);\n', '}\n', '\n', '\n', 'contract SwapContrak \n', '{\n', '    XBL_ERC20Wrapper private ERC20_CALLS;\n', '\n', '    string eosio_username;\n', '    uint256 public register_counter;\n', '\n', '    address public swap_address;\n', '    address public XBLContract_addr;\n', '\n', '    mapping(string => uint256) registered_for_swap_db; \n', '    mapping(uint256 => string) address_to_eosio_username;\n', '\n', '\n', '    constructor() public\n', '    {\n', '        swap_address = address(this); /* Own address */\n', '        register_counter = 0;\n', '        XBLContract_addr = 0x49AeC0752E68D0282Db544C677f6BA407BA17ED7;\n', '        ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);\n', '    }\n', '\n', '    function getPercent(uint8 percent, uint256 number) private returns (uint256 result)\n', '    {\n', '        return number * percent / 100;\n', '    }\n', '    \n', '\n', '    function registerSwap(uint256 xbl_amount, string memory eosio_username) public returns (int256 STATUS_CODE)\n', '    {\n', '        uint256 eosio_balance;\n', '        if (ERC20_CALLS.allowance(msg.sender, swap_address) < xbl_amount)\n', '            return -1;\n', '\n', '        if (ERC20_CALLS.balanceOf(msg.sender) < xbl_amount) \n', '            return - 2;\n', '\n', '        ERC20_CALLS.transferFrom(msg.sender, swap_address, xbl_amount);\n', '        if (xbl_amount >= 5000000000000000000000)\n', '        {\n', '            eosio_balance = xbl_amount +getPercent(5,xbl_amount);\n', '        }\n', '        else\n', '        {\n', '            eosio_balance = xbl_amount;\n', '        }\n', '        registered_for_swap_db[eosio_username] = eosio_balance;\n', '        address_to_eosio_username[register_counter] = eosio_username; \n', '        register_counter += 1;\n', '    }\n', '    \n', '    function getEOSIO_USERNAME(uint256 target) public view returns (string memory eosio_username)\n', '    {\n', '        return address_to_eosio_username[target];\n', '    }\n', '     \n', '    function getBalanceByEOSIO_USERNAME(string memory eosio_username) public view returns (uint256 eosio_balance) \n', '    {\n', '        return registered_for_swap_db[eosio_username];\n', '    }\n', '}']
['pragma solidity ^0.5.2;\n', '\n', '\n', 'contract XBL_ERC20Wrapper\n', '{\n', '    function transferFrom(address from, address to, uint value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public  returns (uint256 remaining);\n', '    function balanceOf(address _owner) public returns (uint256 balance);\n', '}\n', '\n', '\n', 'contract SwapContrak \n', '{\n', '    XBL_ERC20Wrapper private ERC20_CALLS;\n', '\n', '    string eosio_username;\n', '    uint256 public register_counter;\n', '\n', '    address public swap_address;\n', '    address public XBLContract_addr;\n', '\n', '    mapping(string => uint256) registered_for_swap_db; \n', '    mapping(uint256 => string) address_to_eosio_username;\n', '\n', '\n', '    constructor() public\n', '    {\n', '        swap_address = address(this); /* Own address */\n', '        register_counter = 0;\n', '        XBLContract_addr = 0x49AeC0752E68D0282Db544C677f6BA407BA17ED7;\n', '        ERC20_CALLS = XBL_ERC20Wrapper(XBLContract_addr);\n', '    }\n', '\n', '    function getPercent(uint8 percent, uint256 number) private returns (uint256 result)\n', '    {\n', '        return number * percent / 100;\n', '    }\n', '    \n', '\n', '    function registerSwap(uint256 xbl_amount, string memory eosio_username) public returns (int256 STATUS_CODE)\n', '    {\n', '        uint256 eosio_balance;\n', '        if (ERC20_CALLS.allowance(msg.sender, swap_address) < xbl_amount)\n', '            return -1;\n', '\n', '        if (ERC20_CALLS.balanceOf(msg.sender) < xbl_amount) \n', '            return - 2;\n', '\n', '        ERC20_CALLS.transferFrom(msg.sender, swap_address, xbl_amount);\n', '        if (xbl_amount >= 5000000000000000000000)\n', '        {\n', '            eosio_balance = xbl_amount +getPercent(5,xbl_amount);\n', '        }\n', '        else\n', '        {\n', '            eosio_balance = xbl_amount;\n', '        }\n', '        registered_for_swap_db[eosio_username] = eosio_balance;\n', '        address_to_eosio_username[register_counter] = eosio_username; \n', '        register_counter += 1;\n', '    }\n', '    \n', '    function getEOSIO_USERNAME(uint256 target) public view returns (string memory eosio_username)\n', '    {\n', '        return address_to_eosio_username[target];\n', '    }\n', '     \n', '    function getBalanceByEOSIO_USERNAME(string memory eosio_username) public view returns (uint256 eosio_balance) \n', '    {\n', '        return registered_for_swap_db[eosio_username];\n', '    }\n', '}']
