['pragma solidity 0.4.24;\n', '\n', '// File: contracts\\safe_math_lib.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Gas optimization: this is cheaper than requiring &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts\\database.sol\n', '\n', 'contract database {\n', '\n', '    /* libraries */\n', '    using SafeMath for uint256;\n', '\n', '    /* struct declarations */\n', '    struct participant {\n', '        address eth_address; // your eth address\n', '        uint256 topl_address; // your topl address\n', '        uint256 arbits; // the amount of a arbits you have\n', '        uint256 num_of_pro_rata_tokens_alloted;\n', '        bool arbits_kyc_whitelist; // if you pass arbits level kyc you get this\n', '        uint8 num_of_uses;\n', '    }\n', '\n', '    /* variable declarations */\n', '    // permission variables\n', '    mapping(address => bool) public sale_owners;\n', '    mapping(address => bool) public owners;\n', '    mapping(address => bool) public masters;\n', '    mapping(address => bool) public kycers;\n', '\n', '    // database mapping\n', '    mapping(address => participant) public participants;\n', '    address[] public participant_keys;\n', '\n', '    // sale open variables\n', '    bool public arbits_presale_open = false; // Presale variables\n', '    bool public iconiq_presale_open = false; // ^^^^^^^^^^^^^^^^^\n', '    bool public arbits_sale_open = false; // Main sale variables\n', '\n', '    // sale state variables\n', '    uint256 public pre_kyc_bonus_denominator;\n', '    uint256 public pre_kyc_bonus_numerator;\n', '    uint256 public pre_kyc_iconiq_bonus_denominator;\n', '    uint256 public pre_kyc_iconiq_bonus_numerator;\n', '\n', '    uint256 public contrib_arbits_min;\n', '    uint256 public contrib_arbits_max;\n', '\n', '    // presale variables\n', '    uint256 public presale_arbits_per_ether;        // two different prices, but same cap\n', '    uint256 public presale_iconiq_arbits_per_ether; // and sold values\n', '    uint256 public presale_arbits_total = 18000000;\n', '    uint256 public presale_arbits_sold;\n', '\n', '    // main sale variables\n', '    uint256 public sale_arbits_per_ether;\n', '    uint256 public sale_arbits_total;\n', '    uint256 public sale_arbits_sold;\n', '\n', '    /* constructor */\n', '    constructor() public {\n', '        owners[msg.sender] = true;\n', '    }\n', '\n', '    /* permission functions */\n', '    function add_owner(address __subject) public only_owner {\n', '        owners[__subject] = true;\n', '    }\n', '\n', '    function remove_owner(address __subject) public only_owner {\n', '        owners[__subject] = false;\n', '    }\n', '\n', '    function add_master(address _subject) public only_owner {\n', '        masters[_subject] = true;\n', '    }\n', '\n', '    function remove_master(address _subject) public only_owner {\n', '        masters[_subject] = false;\n', '    }\n', '\n', '    function add_kycer(address _subject) public only_owner {\n', '        kycers[_subject] = true;\n', '    }\n', '\n', '    function remove_kycer(address _subject) public only_owner {\n', '        kycers[_subject] = false;\n', '    }\n', '\n', '    /* modifiers */\n', '    modifier log_participant_update(address __eth_address) {\n', '        participant_keys.push(__eth_address); // logs the given address in participant_keys\n', '        _;\n', '    }\n', '\n', '    modifier only_owner() {\n', '        require(owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier only_kycer() {\n', '        require(kycers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier only_master_or_owner() {\n', '        require(masters[msg.sender] || owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /* database functions */\n', '    // GENERAL VARIABLE getters & setters\n', '    // getters    \n', '    function get_sale_owner(address _a) public view returns(bool) {\n', '        return sale_owners[_a];\n', '    }\n', '    \n', '    function get_contrib_arbits_min() public view returns(uint256) {\n', '        return contrib_arbits_min;\n', '    }\n', '\n', '    function get_contrib_arbits_max() public view returns(uint256) {\n', '        return contrib_arbits_max;\n', '    }\n', '\n', '    function get_pre_kyc_bonus_numerator() public view returns(uint256) {\n', '        return pre_kyc_bonus_numerator;\n', '    }\n', '\n', '    function get_pre_kyc_bonus_denominator() public view returns(uint256) {\n', '        return pre_kyc_bonus_denominator;\n', '    }\n', '\n', '    function get_pre_kyc_iconiq_bonus_numerator() public view returns(uint256) {\n', '        return pre_kyc_iconiq_bonus_numerator;\n', '    }\n', '\n', '    function get_pre_kyc_iconiq_bonus_denominator() public view returns(uint256) {\n', '        return pre_kyc_iconiq_bonus_denominator;\n', '    }\n', '\n', '    function get_presale_iconiq_arbits_per_ether() public view returns(uint256) {\n', '        return (presale_iconiq_arbits_per_ether);\n', '    }\n', '\n', '    function get_presale_arbits_per_ether() public view returns(uint256) {\n', '        return (presale_arbits_per_ether);\n', '    }\n', '\n', '    function get_presale_arbits_total() public view returns(uint256) {\n', '        return (presale_arbits_total);\n', '    }\n', '\n', '    function get_presale_arbits_sold() public view returns(uint256) {\n', '        return (presale_arbits_sold);\n', '    }\n', '\n', '    function get_sale_arbits_per_ether() public view returns(uint256) {\n', '        return (sale_arbits_per_ether);\n', '    }\n', '\n', '    function get_sale_arbits_total() public view returns(uint256) {\n', '        return (sale_arbits_total);\n', '    }\n', '\n', '    function get_sale_arbits_sold() public view returns(uint256) {\n', '        return (sale_arbits_sold);\n', '    }\n', '\n', '    // setters\n', '    function set_sale_owner(address _a, bool _v) public only_master_or_owner {\n', '        sale_owners[_a] = _v;\n', '    }\n', '\n', '    function set_contrib_arbits_min(uint256 _v) public only_master_or_owner {\n', '        contrib_arbits_min = _v;\n', '    }\n', '\n', '    function set_contrib_arbits_max(uint256 _v) public only_master_or_owner {\n', '        contrib_arbits_max = _v;\n', '    }\n', '\n', '    function set_pre_kyc_bonus_numerator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_bonus_numerator = _v;\n', '    }\n', '\n', '    function set_pre_kyc_bonus_denominator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_bonus_denominator = _v;\n', '    }\n', '\n', '    function set_pre_kyc_iconiq_bonus_numerator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_iconiq_bonus_numerator = _v;\n', '    }\n', '\n', '    function set_pre_kyc_iconiq_bonus_denominator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_iconiq_bonus_denominator = _v;\n', '    }\n', '\n', '    function set_presale_iconiq_arbits_per_ether(uint256 _v) public only_master_or_owner {\n', '        presale_iconiq_arbits_per_ether = _v;\n', '    }\n', '\n', '    function set_presale_arbits_per_ether(uint256 _v) public only_master_or_owner {\n', '        presale_arbits_per_ether = _v;\n', '    }\n', '\n', '    function set_presale_arbits_total(uint256 _v) public only_master_or_owner {\n', '        presale_arbits_total = _v;\n', '    }\n', '\n', '    function set_presale_arbits_sold(uint256 _v) public only_master_or_owner {\n', '        presale_arbits_sold = _v;\n', '    }\n', '\n', '    function set_sale_arbits_per_ether(uint256 _v) public only_master_or_owner {\n', '        sale_arbits_per_ether = _v;\n', '    }\n', '\n', '    function set_sale_arbits_total(uint256 _v) public only_master_or_owner {\n', '        sale_arbits_total = _v;\n', '    }\n', '\n', '    function set_sale_arbits_sold(uint256 _v) public only_master_or_owner {\n', '        sale_arbits_sold = _v;\n', '    }\n', '\n', '    // PARTICIPANT SPECIFIC getters and setters\n', '    // getters\n', '    function get_participant(address _a) public view returns(\n', '        address,\n', '        uint256,\n', '        uint256,\n', '        uint256,\n', '        bool,\n', '        uint8\n', '    ) {\n', '        participant storage subject = participants[_a];\n', '        return (\n', '            subject.eth_address,\n', '            subject.topl_address,\n', '            subject.arbits,\n', '            subject.num_of_pro_rata_tokens_alloted,\n', '            subject.arbits_kyc_whitelist,\n', '            subject.num_of_uses\n', '        );\n', '    }\n', '\n', '    function get_participant_num_of_uses(address _a) public view returns(uint8) {\n', '        return (participants[_a].num_of_uses);\n', '    }\n', '\n', '    function get_participant_topl_address(address _a) public view returns(uint256) {\n', '        return (participants[_a].topl_address);\n', '    }\n', '\n', '    function get_participant_arbits(address _a) public view returns(uint256) {\n', '        return (participants[_a].arbits);\n', '    }\n', '\n', '    function get_participant_num_of_pro_rata_tokens_alloted(address _a) public view returns(uint256) {\n', '        return (participants[_a].num_of_pro_rata_tokens_alloted);\n', '    }\n', '\n', '    function get_participant_arbits_kyc_whitelist(address _a) public view returns(bool) {\n', '        return (participants[_a].arbits_kyc_whitelist);\n', '    }\n', '\n', '    // setters\n', '    function set_participant(\n', '        address _a,\n', '        uint256 _ta,\n', '        uint256 _arbits,\n', '        uint256 _prta,\n', '        bool _v3,\n', '        uint8 _nou\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participant storage subject = participants[_a];\n', '        subject.eth_address = _a;\n', '        subject.topl_address = _ta;\n', '        subject.arbits = _arbits;\n', '        subject.num_of_pro_rata_tokens_alloted = _prta;\n', '        subject.arbits_kyc_whitelist = _v3;\n', '        subject.num_of_uses = _nou;\n', '    }\n', '\n', '    function set_participant_num_of_uses(\n', '        address _a,\n', '        uint8 _v\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].num_of_uses = _v;\n', '    }\n', '\n', '    function set_participant_topl_address(\n', '        address _a,\n', '        uint256 _ta\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].topl_address = _ta;\n', '    }\n', '\n', '    function set_participant_arbits(\n', '        address _a,\n', '        uint256 _v\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].arbits = _v;\n', '    }\n', '\n', '    function set_participant_num_of_pro_rata_tokens_alloted(\n', '        address _a,\n', '        uint256 _v\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].num_of_pro_rata_tokens_alloted = _v;\n', '    }\n', '\n', '    function set_participant_arbits_kyc_whitelist(\n', '        address _a,\n', '        bool _v\n', '    ) public only_kycer log_participant_update(_a) {\n', '        participants[_a].arbits_kyc_whitelist = _v;\n', '    }\n', '\n', '\n', '    //\n', '    // STATE FLAG FUNCTIONS: Getter, setter, and toggling functions for state flags.\n', '\n', '    // GETTERS\n', '    function get_iconiq_presale_open() public view only_master_or_owner returns(bool) {\n', '        return iconiq_presale_open;\n', '    }\n', '\n', '    function get_arbits_presale_open() public view only_master_or_owner returns(bool) {\n', '        return arbits_presale_open;\n', '    }\n', '\n', '    function get_arbits_sale_open() public view only_master_or_owner returns(bool) {\n', '        return arbits_sale_open;\n', '    }\n', '\n', '    // SETTERS\n', '    function set_iconiq_presale_open(bool _v) public only_master_or_owner {\n', '        iconiq_presale_open = _v;\n', '    }\n', '\n', '    function set_arbits_presale_open(bool _v) public only_master_or_owner {\n', '        arbits_presale_open = _v;\n', '    }\n', '\n', '    function set_arbits_sale_open(bool _v) public only_master_or_owner {\n', '        arbits_sale_open = _v;\n', '    }\n', '\n', '}']
['pragma solidity 0.4.24;\n', '\n', '// File: contracts\\safe_math_lib.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts\\database.sol\n', '\n', 'contract database {\n', '\n', '    /* libraries */\n', '    using SafeMath for uint256;\n', '\n', '    /* struct declarations */\n', '    struct participant {\n', '        address eth_address; // your eth address\n', '        uint256 topl_address; // your topl address\n', '        uint256 arbits; // the amount of a arbits you have\n', '        uint256 num_of_pro_rata_tokens_alloted;\n', '        bool arbits_kyc_whitelist; // if you pass arbits level kyc you get this\n', '        uint8 num_of_uses;\n', '    }\n', '\n', '    /* variable declarations */\n', '    // permission variables\n', '    mapping(address => bool) public sale_owners;\n', '    mapping(address => bool) public owners;\n', '    mapping(address => bool) public masters;\n', '    mapping(address => bool) public kycers;\n', '\n', '    // database mapping\n', '    mapping(address => participant) public participants;\n', '    address[] public participant_keys;\n', '\n', '    // sale open variables\n', '    bool public arbits_presale_open = false; // Presale variables\n', '    bool public iconiq_presale_open = false; // ^^^^^^^^^^^^^^^^^\n', '    bool public arbits_sale_open = false; // Main sale variables\n', '\n', '    // sale state variables\n', '    uint256 public pre_kyc_bonus_denominator;\n', '    uint256 public pre_kyc_bonus_numerator;\n', '    uint256 public pre_kyc_iconiq_bonus_denominator;\n', '    uint256 public pre_kyc_iconiq_bonus_numerator;\n', '\n', '    uint256 public contrib_arbits_min;\n', '    uint256 public contrib_arbits_max;\n', '\n', '    // presale variables\n', '    uint256 public presale_arbits_per_ether;        // two different prices, but same cap\n', '    uint256 public presale_iconiq_arbits_per_ether; // and sold values\n', '    uint256 public presale_arbits_total = 18000000;\n', '    uint256 public presale_arbits_sold;\n', '\n', '    // main sale variables\n', '    uint256 public sale_arbits_per_ether;\n', '    uint256 public sale_arbits_total;\n', '    uint256 public sale_arbits_sold;\n', '\n', '    /* constructor */\n', '    constructor() public {\n', '        owners[msg.sender] = true;\n', '    }\n', '\n', '    /* permission functions */\n', '    function add_owner(address __subject) public only_owner {\n', '        owners[__subject] = true;\n', '    }\n', '\n', '    function remove_owner(address __subject) public only_owner {\n', '        owners[__subject] = false;\n', '    }\n', '\n', '    function add_master(address _subject) public only_owner {\n', '        masters[_subject] = true;\n', '    }\n', '\n', '    function remove_master(address _subject) public only_owner {\n', '        masters[_subject] = false;\n', '    }\n', '\n', '    function add_kycer(address _subject) public only_owner {\n', '        kycers[_subject] = true;\n', '    }\n', '\n', '    function remove_kycer(address _subject) public only_owner {\n', '        kycers[_subject] = false;\n', '    }\n', '\n', '    /* modifiers */\n', '    modifier log_participant_update(address __eth_address) {\n', '        participant_keys.push(__eth_address); // logs the given address in participant_keys\n', '        _;\n', '    }\n', '\n', '    modifier only_owner() {\n', '        require(owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier only_kycer() {\n', '        require(kycers[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier only_master_or_owner() {\n', '        require(masters[msg.sender] || owners[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /* database functions */\n', '    // GENERAL VARIABLE getters & setters\n', '    // getters    \n', '    function get_sale_owner(address _a) public view returns(bool) {\n', '        return sale_owners[_a];\n', '    }\n', '    \n', '    function get_contrib_arbits_min() public view returns(uint256) {\n', '        return contrib_arbits_min;\n', '    }\n', '\n', '    function get_contrib_arbits_max() public view returns(uint256) {\n', '        return contrib_arbits_max;\n', '    }\n', '\n', '    function get_pre_kyc_bonus_numerator() public view returns(uint256) {\n', '        return pre_kyc_bonus_numerator;\n', '    }\n', '\n', '    function get_pre_kyc_bonus_denominator() public view returns(uint256) {\n', '        return pre_kyc_bonus_denominator;\n', '    }\n', '\n', '    function get_pre_kyc_iconiq_bonus_numerator() public view returns(uint256) {\n', '        return pre_kyc_iconiq_bonus_numerator;\n', '    }\n', '\n', '    function get_pre_kyc_iconiq_bonus_denominator() public view returns(uint256) {\n', '        return pre_kyc_iconiq_bonus_denominator;\n', '    }\n', '\n', '    function get_presale_iconiq_arbits_per_ether() public view returns(uint256) {\n', '        return (presale_iconiq_arbits_per_ether);\n', '    }\n', '\n', '    function get_presale_arbits_per_ether() public view returns(uint256) {\n', '        return (presale_arbits_per_ether);\n', '    }\n', '\n', '    function get_presale_arbits_total() public view returns(uint256) {\n', '        return (presale_arbits_total);\n', '    }\n', '\n', '    function get_presale_arbits_sold() public view returns(uint256) {\n', '        return (presale_arbits_sold);\n', '    }\n', '\n', '    function get_sale_arbits_per_ether() public view returns(uint256) {\n', '        return (sale_arbits_per_ether);\n', '    }\n', '\n', '    function get_sale_arbits_total() public view returns(uint256) {\n', '        return (sale_arbits_total);\n', '    }\n', '\n', '    function get_sale_arbits_sold() public view returns(uint256) {\n', '        return (sale_arbits_sold);\n', '    }\n', '\n', '    // setters\n', '    function set_sale_owner(address _a, bool _v) public only_master_or_owner {\n', '        sale_owners[_a] = _v;\n', '    }\n', '\n', '    function set_contrib_arbits_min(uint256 _v) public only_master_or_owner {\n', '        contrib_arbits_min = _v;\n', '    }\n', '\n', '    function set_contrib_arbits_max(uint256 _v) public only_master_or_owner {\n', '        contrib_arbits_max = _v;\n', '    }\n', '\n', '    function set_pre_kyc_bonus_numerator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_bonus_numerator = _v;\n', '    }\n', '\n', '    function set_pre_kyc_bonus_denominator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_bonus_denominator = _v;\n', '    }\n', '\n', '    function set_pre_kyc_iconiq_bonus_numerator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_iconiq_bonus_numerator = _v;\n', '    }\n', '\n', '    function set_pre_kyc_iconiq_bonus_denominator(uint256 _v) public only_master_or_owner {\n', '        pre_kyc_iconiq_bonus_denominator = _v;\n', '    }\n', '\n', '    function set_presale_iconiq_arbits_per_ether(uint256 _v) public only_master_or_owner {\n', '        presale_iconiq_arbits_per_ether = _v;\n', '    }\n', '\n', '    function set_presale_arbits_per_ether(uint256 _v) public only_master_or_owner {\n', '        presale_arbits_per_ether = _v;\n', '    }\n', '\n', '    function set_presale_arbits_total(uint256 _v) public only_master_or_owner {\n', '        presale_arbits_total = _v;\n', '    }\n', '\n', '    function set_presale_arbits_sold(uint256 _v) public only_master_or_owner {\n', '        presale_arbits_sold = _v;\n', '    }\n', '\n', '    function set_sale_arbits_per_ether(uint256 _v) public only_master_or_owner {\n', '        sale_arbits_per_ether = _v;\n', '    }\n', '\n', '    function set_sale_arbits_total(uint256 _v) public only_master_or_owner {\n', '        sale_arbits_total = _v;\n', '    }\n', '\n', '    function set_sale_arbits_sold(uint256 _v) public only_master_or_owner {\n', '        sale_arbits_sold = _v;\n', '    }\n', '\n', '    // PARTICIPANT SPECIFIC getters and setters\n', '    // getters\n', '    function get_participant(address _a) public view returns(\n', '        address,\n', '        uint256,\n', '        uint256,\n', '        uint256,\n', '        bool,\n', '        uint8\n', '    ) {\n', '        participant storage subject = participants[_a];\n', '        return (\n', '            subject.eth_address,\n', '            subject.topl_address,\n', '            subject.arbits,\n', '            subject.num_of_pro_rata_tokens_alloted,\n', '            subject.arbits_kyc_whitelist,\n', '            subject.num_of_uses\n', '        );\n', '    }\n', '\n', '    function get_participant_num_of_uses(address _a) public view returns(uint8) {\n', '        return (participants[_a].num_of_uses);\n', '    }\n', '\n', '    function get_participant_topl_address(address _a) public view returns(uint256) {\n', '        return (participants[_a].topl_address);\n', '    }\n', '\n', '    function get_participant_arbits(address _a) public view returns(uint256) {\n', '        return (participants[_a].arbits);\n', '    }\n', '\n', '    function get_participant_num_of_pro_rata_tokens_alloted(address _a) public view returns(uint256) {\n', '        return (participants[_a].num_of_pro_rata_tokens_alloted);\n', '    }\n', '\n', '    function get_participant_arbits_kyc_whitelist(address _a) public view returns(bool) {\n', '        return (participants[_a].arbits_kyc_whitelist);\n', '    }\n', '\n', '    // setters\n', '    function set_participant(\n', '        address _a,\n', '        uint256 _ta,\n', '        uint256 _arbits,\n', '        uint256 _prta,\n', '        bool _v3,\n', '        uint8 _nou\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participant storage subject = participants[_a];\n', '        subject.eth_address = _a;\n', '        subject.topl_address = _ta;\n', '        subject.arbits = _arbits;\n', '        subject.num_of_pro_rata_tokens_alloted = _prta;\n', '        subject.arbits_kyc_whitelist = _v3;\n', '        subject.num_of_uses = _nou;\n', '    }\n', '\n', '    function set_participant_num_of_uses(\n', '        address _a,\n', '        uint8 _v\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].num_of_uses = _v;\n', '    }\n', '\n', '    function set_participant_topl_address(\n', '        address _a,\n', '        uint256 _ta\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].topl_address = _ta;\n', '    }\n', '\n', '    function set_participant_arbits(\n', '        address _a,\n', '        uint256 _v\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].arbits = _v;\n', '    }\n', '\n', '    function set_participant_num_of_pro_rata_tokens_alloted(\n', '        address _a,\n', '        uint256 _v\n', '    ) public only_master_or_owner log_participant_update(_a) {\n', '        participants[_a].num_of_pro_rata_tokens_alloted = _v;\n', '    }\n', '\n', '    function set_participant_arbits_kyc_whitelist(\n', '        address _a,\n', '        bool _v\n', '    ) public only_kycer log_participant_update(_a) {\n', '        participants[_a].arbits_kyc_whitelist = _v;\n', '    }\n', '\n', '\n', '    //\n', '    // STATE FLAG FUNCTIONS: Getter, setter, and toggling functions for state flags.\n', '\n', '    // GETTERS\n', '    function get_iconiq_presale_open() public view only_master_or_owner returns(bool) {\n', '        return iconiq_presale_open;\n', '    }\n', '\n', '    function get_arbits_presale_open() public view only_master_or_owner returns(bool) {\n', '        return arbits_presale_open;\n', '    }\n', '\n', '    function get_arbits_sale_open() public view only_master_or_owner returns(bool) {\n', '        return arbits_sale_open;\n', '    }\n', '\n', '    // SETTERS\n', '    function set_iconiq_presale_open(bool _v) public only_master_or_owner {\n', '        iconiq_presale_open = _v;\n', '    }\n', '\n', '    function set_arbits_presale_open(bool _v) public only_master_or_owner {\n', '        arbits_presale_open = _v;\n', '    }\n', '\n', '    function set_arbits_sale_open(bool _v) public only_master_or_owner {\n', '        arbits_sale_open = _v;\n', '    }\n', '\n', '}']
