['pragma solidity ^0.4.24;\n', '/*\n', ' *                                └────────────────────┘\n', ' * (Step 1) import this contracts interface into your contract\n', ' * \n', ' *    import "./TeamJustInterface.sol";\n', ' *\n', ' * (Step 2) set up the interface to point to the TeamJust contract\n', ' * \n', ' *    TeamJustInterface constant TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);\n', ' *\n', ' *    modifier onlyAdmins() {require(TeamJust.isAdmin(msg.sender) == true, "onlyAdmins failed - msg.sender is not an admin"); _;}\n', ' *    modifier onlyDevs() {require(TeamJust.isDev(msg.sender) == true, "onlyDevs failed - msg.sender is not a dev"); _;}\n', ' *                                ┌────────────────────┐\n', ' *                                │ Usage Instructions │\n', ' *                                └────────────────────┘\n', ' * use onlyAdmins() and onlyDevs() modifiers as you normally would on any function\n', ' * you wish to restrict to admins/devs registered with this contract.\n', ' * \n', ' * to get required signatures for admins or devs\n', ' *       uint256 x = TeamJust.requiredSignatures();\n', ' *       uint256 x = TeamJust.requiredDevSignatures();\n', ' * \n', ' * to get admin count or dev count \n', ' *       uint256 x = TeamJust.adminCount();\n', ' *       uint256 x = TeamJust.devCount();\n', ' * \n', ' * to get the name of an admin (in bytes32 format)\n', ' *       bytes32 x = TeamJust.adminName(address);\n', ' */\n', '\n', 'interface JIincForwarderInterface {\n', '    function deposit() external payable returns(bool);\n', '    function status() external view returns(address, address, bool);\n', '    function startMigration(address _newCorpBank) external returns(bool);\n', '    function cancelMigration() external returns(bool);\n', '    function finishMigration() external returns(bool);\n', '    function setup(address _firstCorpBank) external;\n', '}\n', '\n', 'contract TeamJust {\n', '    JIincForwarderInterface private Jekyll_Island_Inc = JIincForwarderInterface(0x0);\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // SET UP MSFun (note, check signers by name is modified from MSFun sdk)\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    MSFun.Data private msData;\n', '    function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}\n', '    function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32 message_data, uint256 signature_count) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}\n', '    function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}\n', '\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // DATA SETUP\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    struct Admin {\n', '        bool isAdmin;\n', '        bool isDev;\n', '        bytes32 name;\n', '    }\n', '    mapping (address => Admin) admins_;\n', '    \n', '    uint256 adminCount_;\n', '    uint256 devCount_;\n', '    uint256 requiredSignatures_;\n', '    uint256 requiredDevSignatures_;\n', '    \n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // CONSTRUCTOR\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    constructor()\n', '        public\n', '    {\n', '        address daddy = 0xC018492974D65c3B3A9FcE1B9f7577505F31A7D8;\n', '        address suoha   = 0x55636a5fD4A78d86415B72e09E131D9D0e095e57;\n', '        address nodumb    = 0xe948b1fF4e02cf8fa0A5Cc479b98E52022Aa5acF;\n', '        address dddos  = 0x8cFD216Eb0a305Af16f838396DFD6BDeDecd0689;\n', '\t\taddress deployer = 0x3705B81d42199138E53FB0Ad57613ce309576077;\n', '        \n', '        admins_[daddy] = Admin(true, true, "daddy");\n', '        admins_[suoha]   = Admin(true, true, "suoha");\n', '        admins_[nodumb]    = Admin(true, true, "nodumb");\n', '        admins_[dddos]  = Admin(true, true, "dddos");\n', '\t\tadmins_[deployer] = Admin(true, true, "deployer");\n', '        \n', '        adminCount_ = 5;\n', '        devCount_ = 5;\n', '        requiredSignatures_ = 1;\n', '        requiredDevSignatures_ = 1;\n', '    }\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // FALLBACK, SETUP, AND FORWARD\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // there should never be a balance in this contract.  but if someone\n', '    // does stupidly send eth here for some reason.  we can forward it \n', '    // to jekyll island\n', '    function ()\n', '        public\n', '        payable\n', '    {\n', '        Jekyll_Island_Inc.deposit.value(address(this).balance)();\n', '    }\n', '    \n', '    function setup(address _addr)\n', '        onlyDevs()\n', '        public\n', '    {\n', '        require( address(Jekyll_Island_Inc) == address(0) );\n', '        Jekyll_Island_Inc = JIincForwarderInterface(_addr);\n', '    }    \n', '    \n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // MODIFIERS\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    modifier onlyDevs()\n', '    {\n', '        require(admins_[msg.sender].isDev == true, "onlyDevs failed - msg.sender is not a dev");\n', '        _;\n', '    }\n', '    \n', '    modifier onlyAdmins()\n', '    {\n', '        require(admins_[msg.sender].isAdmin == true, "onlyAdmins failed - msg.sender is not an admin");\n', '        _;\n', '    }\n', '\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // DEV ONLY FUNCTIONS\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    /**\n', '    * @dev DEV - use this to add admins.  this is a dev only function.\n', '    * @param _who - address of the admin you wish to add\n', '    * @param _name - admins name\n', '    * @param _isDev - is this admin also a dev?\n', '    */\n', '    function addAdmin(address _who, bytes32 _name, bool _isDev)\n', '        public\n', '        onlyDevs()\n', '    {\n', '        if (MSFun.multiSig(msData, requiredDevSignatures_, "addAdmin") == true) \n', '        {\n', '            MSFun.deleteProposal(msData, "addAdmin");\n', '            \n', '            // must check this so we dont mess up admin count by adding someone\n', '            // who is already an admin\n', '            if (admins_[_who].isAdmin == false) \n', '            { \n', '                \n', '                // set admins flag to true in admin mapping\n', '                admins_[_who].isAdmin = true;\n', '        \n', '                // adjust admin count and required signatures\n', '                adminCount_ += 1;\n', '                requiredSignatures_ += 1;\n', '            }\n', '            \n', '            // are we setting them as a dev?\n', '            // by putting this outside the above if statement, we can upgrade existing\n', '            // admins to devs.\n', '            if (_isDev == true) \n', '            {\n', '                // bestow the honored dev status\n', '                admins_[_who].isDev = _isDev;\n', '                \n', '                // increase dev count and required dev signatures\n', '                devCount_ += 1;\n', '                requiredDevSignatures_ += 1;\n', '            }\n', '        }\n', '        \n', '        // by putting this outside the above multisig, we can allow easy name changes\n', '        // without having to bother with multisig.  this will still create a proposal though\n', '        // so use the deleteAnyProposal to delete it if you want to\n', '        admins_[_who].name = _name;\n', '    }\n', '\n', '    /**\n', '    * @dev DEV - use this to remove admins. this is a dev only function.\n', '    * -requirements: never less than 1 admin\n', '    *                never less than 1 dev\n', '    *                never less admins than required signatures\n', '    *                never less devs than required dev signatures\n', '    * @param _who - address of the admin you wish to remove\n', '    */\n', '    function removeAdmin(address _who)\n', '        public\n', '        onlyDevs()\n', '    {\n', '        // we can put our requires outside the multisig, this will prevent\n', '        // creating a proposal that would never pass checks anyway.\n', '        require(adminCount_ > 1, "removeAdmin failed - cannot have less than 2 admins");\n', '        require(adminCount_ >= requiredSignatures_, "removeAdmin failed - cannot have less admins than number of required signatures");\n', '        if (admins_[_who].isDev == true)\n', '        {\n', '            require(devCount_ > 1, "removeAdmin failed - cannot have less than 2 devs");\n', '            require(devCount_ >= requiredDevSignatures_, "removeAdmin failed - cannot have less devs than number of required dev signatures");\n', '        }\n', '        \n', '        // checks passed\n', '        if (MSFun.multiSig(msData, requiredDevSignatures_, "removeAdmin") == true) \n', '        {\n', '            MSFun.deleteProposal(msData, "removeAdmin");\n', '            \n', '            // must check this so we dont mess up admin count by removing someone\n', '            // who wasnt an admin to start with\n', '            if (admins_[_who].isAdmin == true) {  \n', '                \n', '                //set admins flag to false in admin mapping\n', '                admins_[_who].isAdmin = false;\n', '                \n', '                //adjust admin count and required signatures\n', '                adminCount_ -= 1;\n', '                if (requiredSignatures_ > 1) \n', '                {\n', '                    requiredSignatures_ -= 1;\n', '                }\n', '            }\n', '            \n', '            // were they also a dev?\n', '            if (admins_[_who].isDev == true) {\n', '                \n', '                //set dev flag to false\n', '                admins_[_who].isDev = false;\n', '                \n', '                //adjust dev count and required dev signatures\n', '                devCount_ -= 1;\n', '                if (requiredDevSignatures_ > 1) \n', '                {\n', '                    requiredDevSignatures_ -= 1;\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev DEV - change the number of required signatures.  must be between\n', '    * 1 and the number of admins.  this is a dev only function\n', '    * @param _howMany - desired number of required signatures\n', '    */\n', '    function changeRequiredSignatures(uint256 _howMany)\n', '        public\n', '        onlyDevs()\n', '    {  \n', '        // make sure its between 1 and number of admins\n', '        require(_howMany > 0 && _howMany <= adminCount_, "changeRequiredSignatures failed - must be between 1 and number of admins");\n', '        \n', '        if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredSignatures") == true) \n', '        {\n', '            MSFun.deleteProposal(msData, "changeRequiredSignatures");\n', '            \n', '            // store new setting.\n', '            requiredSignatures_ = _howMany;\n', '        }\n', '    }\n', '    \n', '    /**\n', '    * @dev DEV - change the number of required dev signatures.  must be between\n', '    * 1 and the number of devs.  this is a dev only function\n', '    * @param _howMany - desired number of required dev signatures\n', '    */\n', '    function changeRequiredDevSignatures(uint256 _howMany)\n', '        public\n', '        onlyDevs()\n', '    {  \n', '        // make sure its between 1 and number of admins\n', '        require(_howMany > 0 && _howMany <= devCount_, "changeRequiredDevSignatures failed - must be between 1 and number of devs");\n', '        \n', '        if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredDevSignatures") == true) \n', '        {\n', '            MSFun.deleteProposal(msData, "changeRequiredDevSignatures");\n', '            \n', '            // store new setting.\n', '            requiredDevSignatures_ = _howMany;\n', '        }\n', '    }\n', '\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // EXTERNAL FUNCTIONS \n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    function requiredSignatures() external view returns(uint256) {return(requiredSignatures_);}\n', '    function requiredDevSignatures() external view returns(uint256) {return(requiredDevSignatures_);}\n', '    function adminCount() external view returns(uint256) {return(adminCount_);}\n', '    function devCount() external view returns(uint256) {return(devCount_);}\n', '    function adminName(address _who) external view returns(bytes32) {return(admins_[_who].name);}\n', '    function isAdmin(address _who) external view returns(bool) {return(admins_[_who].isAdmin);}\n', '    function isDev(address _who) external view returns(bool) {return(admins_[_who].isDev);}\n', '}\n', '\n', 'library MSFun {\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // DATA SETS\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // contact data setup\n', '    struct Data \n', '    {\n', '        mapping (bytes32 => ProposalData) proposal_;\n', '    }\n', '    struct ProposalData \n', '    {\n', '        // a hash of msg.data \n', '        bytes32 msgData;\n', '        // number of signers\n', '        uint256 count;\n', '        // tracking of wither admins have signed\n', '        mapping (address => bool) admin;\n', '        // list of admins who have signed\n', '        mapping (uint256 => address) log;\n', '    }\n', '    \n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // MULTI SIG FUNCTIONS\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)\n', '        internal\n', '        returns(bool) \n', '    {\n', '        // our proposal key will be a hash of our function name + our contracts address \n', '        // by adding our contracts address to this, we prevent anyone trying to circumvent\n', '        // the proposal&#39;s security via external calls.\n', '        bytes32 _whatProposal = whatProposal(_whatFunction);\n', '        \n', '        // this is just done to make the code more readable.  grabs the signature count\n', '        uint256 _currentCount = self.proposal_[_whatProposal].count;\n', '        \n', '        // store the address of the person sending the function call.  we use msg.sender \n', '        // here as a layer of security.  in case someone imports our contract and tries to \n', '        // circumvent function arguments.  still though, our contract that imports this\n', '        // library and calls multisig, needs to use onlyAdmin modifiers or anyone who\n', '        // calls the function will be a signer. \n', '        address _whichAdmin = msg.sender;\n', '        \n', '        // prepare our msg data.  by storing this we are able to verify that all admins\n', '        // are approving the same argument input to be executed for the function.  we hash \n', '        // it and store in bytes32 so its size is known and comparable\n', '        bytes32 _msgData = keccak256(msg.data);\n', '        \n', '        // check to see if this is a new execution of this proposal or not\n', '        if (_currentCount == 0)\n', '        {\n', '            // if it is, lets record the original signers data\n', '            self.proposal_[_whatProposal].msgData = _msgData;\n', '            \n', '            // record original senders signature\n', '            self.proposal_[_whatProposal].admin[_whichAdmin] = true;        \n', '            \n', '            // update log (used to delete records later, and easy way to view signers)\n', '            // also useful if the calling function wants to give something to a \n', '            // specific signer.  \n', '            self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  \n', '            \n', '            // track number of signatures\n', '            self.proposal_[_whatProposal].count += 1;  \n', '            \n', '            // if we now have enough signatures to execute the function, lets\n', '            // return a bool of true.  we put this here in case the required signatures\n', '            // is set to 1.\n', '            if (self.proposal_[_whatProposal].count == _requiredSignatures) {\n', '                return(true);\n', '            }            \n', '        // if its not the first execution, lets make sure the msgData matches\n', '        } else if (self.proposal_[_whatProposal].msgData == _msgData) {\n', '            // msgData is a match\n', '            // make sure admin hasnt already signed\n', '            if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) \n', '            {\n', '                // record their signature\n', '                self.proposal_[_whatProposal].admin[_whichAdmin] = true;        \n', '                \n', '                // update log (used to delete records later, and easy way to view signers)\n', '                self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  \n', '                \n', '                // track number of signatures\n', '                self.proposal_[_whatProposal].count += 1;  \n', '            }\n', '            \n', '            // if we now have enough signatures to execute the function, lets\n', '            // return a bool of true.\n', '            // we put this here for a few reasons.  (1) in normal operation, if \n', '            // that last recorded signature got us to our required signatures.  we \n', '            // need to return bool of true.  (2) if we have a situation where the \n', '            // required number of signatures was adjusted to at or lower than our current \n', '            // signature count, by putting this here, an admin who has already signed,\n', '            // can call the function again to make it return a true bool.  but only if\n', '            // they submit the correct msg data\n', '            if (self.proposal_[_whatProposal].count == _requiredSignatures) {\n', '                return(true);\n', '            }\n', '        }\n', '    }\n', '    \n', '    \n', '    // deletes proposal signature data after successfully executing a multiSig function\n', '    function deleteProposal(Data storage self, bytes32 _whatFunction)\n', '        internal\n', '    {\n', '        //done for readability sake\n', '        bytes32 _whatProposal = whatProposal(_whatFunction);\n', '        address _whichAdmin;\n', '        \n', '        //delete the admins votes & log.   i know for loops are terrible.  but we have to do this \n', '        //for our data stored in mappings.  simply deleting the proposal itself wouldn&#39;t accomplish this.\n', '        for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {\n', '            _whichAdmin = self.proposal_[_whatProposal].log[i];\n', '            delete self.proposal_[_whatProposal].admin[_whichAdmin];\n', '            delete self.proposal_[_whatProposal].log[i];\n', '        }\n', '        //delete the rest of the data in the record\n', '        delete self.proposal_[_whatProposal];\n', '    }\n', '    \n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // HELPER FUNCTIONS\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '\n', '    function whatProposal(bytes32 _whatFunction)\n', '        private\n', '        view\n', '        returns(bytes32)\n', '    {\n', '        return(keccak256(abi.encodePacked(_whatFunction,this)));\n', '    }\n', '    \n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // VANITY FUNCTIONS\n', '    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n', '    // returns a hashed version of msg.data sent by original signer for any given function\n', '    function checkMsgData (Data storage self, bytes32 _whatFunction)\n', '        internal\n', '        view\n', '        returns (bytes32 msg_data)\n', '    {\n', '        bytes32 _whatProposal = whatProposal(_whatFunction);\n', '        return (self.proposal_[_whatProposal].msgData);\n', '    }\n', '    \n', '    // returns number of signers for any given function\n', '    function checkCount (Data storage self, bytes32 _whatFunction)\n', '        internal\n', '        view\n', '        returns (uint256 signature_count)\n', '    {\n', '        bytes32 _whatProposal = whatProposal(_whatFunction);\n', '        return (self.proposal_[_whatProposal].count);\n', '    }\n', '    \n', '    // returns address of an admin who signed for any given function\n', '    function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)\n', '        internal\n', '        view\n', '        returns (address signer)\n', '    {\n', '        require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");\n', '        bytes32 _whatProposal = whatProposal(_whatFunction);\n', '        return (self.proposal_[_whatProposal].log[_signer - 1]);\n', '    }\n', '}']