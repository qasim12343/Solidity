// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;


contract StudentElection {
    struct Student{
        string name;
        uint vote_count;
        uint256 addr;
        uint valid_credite;

    }
    uint256 maxVoters;
    uint256 registered_voters;
    uint256 startTime;
    uint256 endTime;
    uint256 noCandidates;
    string[] participants;

    mapping (uint256 => Student) candidates;
    mapping (uint256 => Student) voters;
    event ElectionResult(string result);
    constructor(uint256 uinxEndTime,uint256 unixStartTime
               ,string[] memory candidatesName,uint16 no_Voters) {
        maxVoters = no_Voters;
        startTime = unixStartTime;
        endTime = uinxEndTime ;
        noCandidates = candidatesName.length;
        registered_voters = 0;
        
       
        for(uint16 i = 0 ; i < noCandidates ; i++){
            candidates[i] = Student(candidatesName[i],0,i,0);
        }
    }
    function compareStrings(string memory a, string memory b)private pure returns (bool) {
        bytes memory aBytes = bytes(a);
        bytes memory bBytes = bytes(b);

        if (aBytes.length != bBytes.length) {
            return false;
        }

        for (uint i = 0; i < aBytes.length; i++) {
            if (aBytes[i] != bBytes[i]) {
                return false;
            }
        }

        return true;
    }
    function check(string[] memory arr, string memory name)public pure returns(bool){
        for (uint i = 0; i < arr.length; i++) 
        {
            if(compareStrings(arr[i], name)){
                return true;
            }
        }
        return false;
    }
    function register_voters(string[] memory voter_names)public {
        require(voter_names.length <= maxVoters,"size of voters > max voters");
        if (registered_voters + voter_names.length <= maxVoters){
            uint256 temp = registered_voters;
            registered_voters = 0;
            require(temp + voter_names.length <= maxVoters,"whole registeration is cancled");
        }
        for (uint i = 0; i < registered_voters; i++) 
        {
            require(!check(voter_names, voters[i].name),"any voter is exist");
        }
        for (uint i = registered_voters; i < registered_voters + voter_names.length ; i++) 
        {
            voters[i] = Student(voter_names[i - registered_voters],0,i,10);
        }
        registered_voters += voter_names.length;

           
    }
    function vote(uint256 addr_voter, uint addr_candidate) public {
        require(startTime <= block.timestamp ,"election is not started");
        require(block.timestamp <= endTime,"election is closed");
        require(addr_candidate < noCandidates,"invalid candidate address");
        require(addr_voter < registered_voters, "invalid voter address");
        require(voters[addr_voter].valid_credite > 0,"you have already finished your credite");
        voters[addr_voter].valid_credite -= 1;
        candidates[addr_candidate].vote_count += 1;
        if(!check(participants, voters[addr_voter].name)){
            participants.push(voters[addr_voter].name);
        }

    }
    function transferCredite(uint256 addr_sender, uint256 addr_reciever, uint amount)public {
        require(addr_sender < registered_voters, "invalid voter1 address");
        require(addr_reciever < registered_voters, "invalid voter2 address");
        require(voters[addr_sender].valid_credite >= amount,"you have already finished your credite");
        voters[addr_reciever].valid_credite += amount;
        voters[addr_sender].valid_credite -= amount;
    }

    function chargeElectionDate(uint256 additional_time)public {
        endTime = endTime + additional_time;
    }

    function announce_result()public returns(string memory){
        require(participants.length >= registered_voters/2,"Election is canceled");
        Student memory s = Student("",0,0,0);
        bool noWinner = false;
        for (uint i = 0; i < noCandidates; i++) 
        {
            if(s.vote_count == candidates[i].vote_count){
                noWinner = true;
            }
            if(s.vote_count < candidates[i].vote_count){
                noWinner = false;
                s = candidates[i];
            }
        }
        string memory result = "";
        if(noWinner){
            result =  "NO_WINNER";
        }else{
            result = s.name;
        }
        emit ElectionResult(result);
        return result;
    }
}