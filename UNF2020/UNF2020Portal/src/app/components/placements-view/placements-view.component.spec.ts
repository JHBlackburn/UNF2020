import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PlacementsViewComponent } from './placements-view.component';

describe('PlacementsViewComponent', () => {
  let component: PlacementsViewComponent;
  let fixture: ComponentFixture<PlacementsViewComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PlacementsViewComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PlacementsViewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
