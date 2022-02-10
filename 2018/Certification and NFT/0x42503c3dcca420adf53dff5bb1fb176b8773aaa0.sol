['pragma solidity ^0.4.24;\n', '/*\n', ' * @title -Jekyll Island- CORP BANK FORWARDER v0.4.6\n', ' * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐\n', ' *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐\n', ' *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘\n', ' *                                  _____                      _____\n', ' *                                 (, /     /)       /) /)    (, /      /)          /)\n', ' *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/\n', ' *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_\n', ' *          ┴ ┴                /   /          .-/ _____   (__ /                               \n', ' *                            (__ /          (_/ (, /                                      /)™ \n', ' *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/\n', ' * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_\n', ' * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  &#169; Jekyll Island Inc. 2018\n', ' * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/\n', ' *====/$$$$$===========/$$=================/$$ /$$====/$$$$$$===========/$$===========================/$$=*\n', ' *   |__  $$          | $$                | $$| $$   |_  $$_/          | $$                          | $$\n', ' *      | $$  /$$$$$$ | $$   /$$ /$$   /$$| $$| $$     | $$    /$$$$$$$| $$  /$$$$$$  /$$$$$$$   /$$$$$$$\n', ' *      | $$ /$$__  $$| $$  /$$/| $$  | $$| $$| $$     | $$   /$$_____/| $$ |____  $$| $$__  $$ /$$__  $$\n', ' * /$$  | $$| $$$$$$$$| $$$$$$/ | $$  | $$| $$| $$     | $$  |  $$$$$$ | $$  /$$$$$$$| $$  \\ $$| $$  | $$\n', ' *| $$  | $$| $$_____/| $$_  $$ | $$  | $$| $$| $$     | $$   \\____  $$| $$ /$$__  $$| $$  | $$| $$  | $$\n', ' *|  $$$$$$/|  $$$$$$$| $$ \\  $$|  $$$$$$$| $$| $$    /$$$$$$ /$$$$$$$/| $$|  $$$$$$$| $$  | $$|  $$$$$$$\n', ' * \\______/  \\_______/|__/  \\__/ \\____  $$|__/|__/   |______/|_______/ |__/ \\_______/|__/  |__/ \\_______/\n', ' *===============================/$$  | $$ Inc.  ╔═╗╔═╗╦═╗╔═╗  ╔╗ ╔═╗╔╗╔╦╔═  ┌─┐┌─┐┬─┐┬ ┬┌─┐┬─┐┌┬┐┌─┐┬─┐                                 \n', ' *                              |  $$$$$$/=======║  ║ ║╠╦╝╠═╝  ╠╩╗╠═╣║║║╠╩╗  ├┤ │ │├┬┘│││├─┤├┬┘ ││├┤ ├┬┘  \n', ' *                               \\______/        ╚═╝╚═╝╩╚═╩    ╚═╝╩ ╩╝╚╝╩ ╩  └  └─┘┴└─└┴┘┴ ┴┴└──┴┘└─┘┴└─==*\n', ' * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐                       \n', ' * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │                      \n', ' * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘                      \n', ' *===========================================================================================*\n', ' *                                ┌────────────────────┐\n', ' *                                │ Setup Instructions │\n', ' *                                └────────────────────┘\n', ' * (Step 1) import the Jekyll Island Inc Forwarder Interface into your contract\n', ' * \n', ' *    import "./JIincForwarderInterface.sol";\n', ' *\n', ' * (Step 2) set it to point to the forwarder\n', ' * \n', ' *    JIincForwarderInterface private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);\n', ' *                                ┌────────────────────┐\n', ' *                                │ Usage Instructions │\n', ' *                                └────────────────────┘\n', ' * whenever your contract needs to send eth to the corp bank, simply use the \n', ' * the following command:\n', ' *\n', ' *    Jekyll_Island_Inc.deposit.value(amount)()\n', ' * \n', ' * OPTIONAL:\n', ' * if you need to be checking wither the transaction was successful, the deposit function returns \n', ' * a bool indicating wither or not it was successful.  so another way to call this function \n', ' * would be:\n', ' * \n', ' *    require(Jekyll_Island_Inc.deposit.value(amount)() == true, "Jekyll Island deposit failed");\n', ' * \n', ' */\n', '\n', 'interface JIincInterfaceForForwarder {\n', '    function deposit(address _addr) external payable returns (bool);\n', '    function migrationReceiver_setup() external returns (bool);\n', '}\n', '\n', 'contract JIincForwarder {\n', '    string public name = "JIincForwarder";\n', '    JIincInterfaceForForwarder private currentCorpBank_;\n', '    address private newCorpBank_;\n', '    bool needsBank_ = true;\n', '    \n', '    constructor() \n', '        public\n', '    {\n', '        //constructor does nothing.\n', '    }\n', '    \n', '    function()\n', '        public\n', '        payable\n', '    {\n', '        // done so that if any one tries to dump eth into this contract, we can\n', '        // just forward it to corp bank.\n', '        currentCorpBank_.deposit.value(address(this).balance)(address(currentCorpBank_));\n', '    }\n', '    \n', '    function deposit()\n', '        public \n', '        payable\n', '        returns(bool)\n', '    {\n', '        require(msg.value > 0, "Forwarder Deposit failed - zero deposits not allowed");\n', '        require(needsBank_ == false, "Forwarder Deposit failed - no registered bank");\n', '        if (currentCorpBank_.deposit.value(msg.value)(msg.sender) == true)\n', '            return(true);\n', '        else\n', '            return(false);\n', '    }\n', '//==============================================================================\n', '//     _ _ . _  _ _ _|_. _  _   .\n', '//    | | ||(_|| (_| | |(_)| |  .\n', '//===========_|=================================================================    \n', '    function status()\n', '        public\n', '        view\n', '        returns(address, address, bool)\n', '    {\n', '        return(address(currentCorpBank_), address(newCorpBank_), needsBank_);\n', '    }\n', '\n', '    function startMigration(address _newCorpBank)\n', '        external\n', '        returns(bool)\n', '    {\n', '        // make sure this is coming from current corp bank\n', '        require(msg.sender == address(currentCorpBank_), "Forwarder startMigration failed - msg.sender must be current corp bank");\n', '        \n', '        // communicate with the new corp bank and make sure it has the forwarder \n', '        // registered \n', '        if(JIincInterfaceForForwarder(_newCorpBank).migrationReceiver_setup() == true)\n', '        {\n', '            // save our new corp bank address\n', '            newCorpBank_ = _newCorpBank;\n', '            return (true);\n', '        } else \n', '            return (false);\n', '    }\n', '    \n', '    function cancelMigration()\n', '        external\n', '        returns(bool)\n', '    {\n', '        // make sure this is coming from the current corp bank (also lets us know \n', '        // that current corp bank has not been killed)\n', '        require(msg.sender == address(currentCorpBank_), "Forwarder cancelMigration failed - msg.sender must be current corp bank");\n', '        \n', '        // erase stored new corp bank address;\n', '        newCorpBank_ = address(0x0);\n', '        \n', '        return (true);\n', '    }\n', '    \n', '    function finishMigration()\n', '        external\n', '        returns(bool)\n', '    {\n', '        // make sure its coming from new corp bank\n', '        require(msg.sender == newCorpBank_, "Forwarder finishMigration failed - msg.sender must be new corp bank");\n', '\n', '        // update corp bank address        \n', '        currentCorpBank_ = (JIincInterfaceForForwarder(newCorpBank_));\n', '        \n', '        // erase new corp bank address\n', '        newCorpBank_ = address(0x0);\n', '        \n', '        return (true);\n', '    }\n', '//==============================================================================\n', '//    . _ ._|_. _ |   _ _ _|_    _   .\n', '//    || || | |(_||  _\\(/_ | |_||_)  .  (this only runs once ever)\n', '//==============================|===============================================\n', '    function setup(address _firstCorpBank)\n', '        external\n', '    {\n', '        require(needsBank_ == true, "Forwarder setup failed - corp bank already registered");\n', '        currentCorpBank_ = JIincInterfaceForForwarder(_firstCorpBank);\n', '        needsBank_ = false;\n', '    }\n', '}']