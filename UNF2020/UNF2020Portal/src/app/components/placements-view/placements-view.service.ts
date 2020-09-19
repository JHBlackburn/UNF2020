import { Injectable } from '@angular/core';
import {Placement} from "./placements-view.component";

@Injectable({providedIn:"root"})

export class PlacementsViewService{
    placements: Placement[] = []
    constructor(){
        this.mockPlacements()
    }

    mockPlacements(){
        this.placements = [
            {
                id: 1,
                personFirstName: "John",
                personLastName: "Smith",
                personGender: "Male",
                companyName: "Suddath",
                companyCity: "Jacksonville",
                companyState: "FL",
                industry: "Transportation",
                positionTitle: "Software Developer",
                startYearlySalary: 10000000.99,
                startDate: new Date(2020, 1, 2),
                endDate: null,
            },
            {
                id: 2,
                personFirstName: "Roman",
                personLastName: "Rojas",
                personGender: "Male",
                companyName: "Suddath",
                companyCity: "Jacksonville",
                companyState: "FL",
                industry: "Transportation",
                positionTitle: "Software Developer",
                startYearlySalary: 20000000.99,
                startDate: new Date(2020, 4, 5),
                endDate: new Date(2020, 11, 5),
            }

        ]
    }

    getPlacements(): Placement[] {
        return this.placements;
    }
}