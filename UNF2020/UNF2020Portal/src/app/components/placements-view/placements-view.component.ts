import { Component, OnInit } from '@angular/core';
import { PlacementsViewService } from './placements-view.service';

export interface Placement {
  id: number,
  personFirstName: string,
  personLastName: string,
  personGender: string,
  companyName: string,
  companyCity: string,
  companyState: string,
  industry: string,
  positionTitle: string,
  startYearlySalary: number,
  startDate: Date,
  endDate: Date,
}



@Component({
  selector: 'app-placements-view',
  templateUrl: './placements-view.component.html',
  styleUrls: ['./placements-view.component.scss']
})
export class PlacementsViewComponent implements OnInit {

  placements: Placement[] = []
  placementDefinitions: string[] = [
    "Id",
    "PersonFirstName",
    "PersonLastName",
    "PersonGender",
    "CompanyName",
    "CompanyCity",
    "CompanyState",
    "Industry",
    "PositionTitle",
    "StartYearlySalary",
    "StartDate",
    "EndDate",
  ]

  constructor(private placementsViewService: PlacementsViewService) {

   }

   getPlacements(){
    this.placements = this.placementsViewService.getPlacements()
   }

   getPlacementProps(placement: Placement): string[]{
    let something =  Object.keys(placement)
    console.log("something:", something)
    return something
   }

  ngOnInit(): void {
    this.getPlacements()
  }

}
